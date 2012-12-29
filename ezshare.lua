local ffi = require("ffi")
local C = ffi.C

local ubc = ffi.load("ezshare")
require"sha1"

ffi.cdef[[

typedef void* tpeer;

tpeer peer_create(int isServer);

int peer_broadcast(tpeer peerIn, char* msg, unsigned int size);

void peer_destroy(tpeer p);

/* timeout is milliseconds */
int peer_select(tpeer peerIn, int timeout);

int peer_receive(tpeer peerIn, char* buf, int bufsize);

typedef void (*file_selected_fun)(char* filename);
void on_file_selected (file_selected_fun fun);

struct HINSTANCE__ { int unused; }; typedef struct HINSTANCE__ *HINSTANCE;
void start( HINSTANCE hInstance, int nCmdShow );

int tick();

void sleep(int n);

typedef void (*log_fun)(char* filename);

__declspec(dllexport) void set_log_fun(log_fun fun);

]]

-- udp max packet length = 65507. we'll risk it, but see:
-- http://stackoverflow.com/questions/3292281/udp-sendto-and-recvfrom-max-buffer-size

packetlen=512--65500

-- header field sizes in bytes
local versionsize = 1
local filenamelensize = 2
local contentlensize = 4
local fromsize = 4
local seqsize = 4

local headerlen = versionsize + filenamelensize + contentlensize + fromsize + seqsize
local bodylen = packetlen - headerlen

local logfile = io.open ("./log.txt", "r")

if io.type(logfile) == 'file' then
   logfile = io.open ("./log2.txt", "w")
else
   logfile = io.open ("./log.txt", "w")
end

maxint = 3000000000

local sendpacketbuf = ffi.new('char[?]', packetlen)

local recvpacketbuf = ffi.new('char[?]', packetlen)

local waitLength = 25

--[[

lengthsize=16
idsize = 64
opcodesize=8
flagsize=64
checksumsize=20
]]

local client, server, self = nil, nil, nil
local CLIENT, SERVER = 0, 1
local cliOnly = false

local files = {}

function exit(v)
   ffi.C.exit(v)
end

function log(msg, lvl)
   logfile:write(tostring(msg).."\n")
   logfile:flush()
end

function fail(msg)
   log(tostring(msg).."\n")
   exit(1)
end

function startNetwork()
   client = ubc.peer_create(CLIENT)
   if not cliOnly then
      server = ubc.peer_create(SERVER)
   end
   self = math.random(maxint)
   log('net is up')
end

function nextPacketBuf()
   if cliOnly then
      ubc.sleep(waitLength)
      return nil, 0
   end
   -- spare the cpu with waitLength millisec timeout
   n = ubc.peer_select(server, waitLength)
 
   if n < 0 then
      fail("bad select")
   elseif n ~= 0 then
      log("packet")
      n = ubc.peer_receive(server, recvpacketbuf, packetlen)
      return recvpacketbuf, n
   else
      return nil, 0
   end
end

function isKnownFile(packet)
   return files[packet.from] ~= nil and 
      files[packet.from][packet.filename] ~= nil
end

function getFile(packet)
   return isKnownFile(packet) and files[packet.from][packet.filename]
end

function isWrongSeq(packet)
   local file = getFile(packet)
   return file and file[nextSeq] ~= packet.seq
end

function isNewFile(packet)
   return not isKnownFile(packet)
end

function isDone(file)
   return file.numPackets == file.nextSeq
end

function startFile(packet)
   log("start file")
   if files[packet.from] == nil then
      files[packet.from] = {}
   end
   packets={}
   packets[0]=packet
   file = { 
      numPackets=packet.numPackets,
      fileSize=packet.fileSize,
      packets=packets,
      nextSeq=1
   }
   files[packet.from][packet.filename] = file
   if isDone(file) then
      log("done")
      file.packets=nil -- reclaim
      return true, file
   else
      return false
   end
end

function writeChunk(filename, content)
   assert(C.fwrite(content, 1, n, files[filename].file) == n)
end

function continueFile(packet)
   log("continue")
   local file = getFile(packet)
   if isDone(file) then
      error("bad continue")
   end
   assert(file[nextSeq] == packet.seq)
   file.packets[packet.seq] = packet
   writeChunk(file.filename, packet.content)
   file.nextSeq = file.nextSeq + 1
   if isDone(packet) then
      log("done")
      return true, file
   else
      return false
   end
end

function reset(packet)
   log("reset")
end

function tickNetwork()
   local has, packet = makeRecvPacket()
   if has and packet.from ~= self then
      if isWrongSeq(packet) then
	 reset(packet)
	 return false
      elseif isNewFile(packet) then
	 return startFile(packet)
      elseif has then
	 return continueFile(packet)
      end
   end
   -- drop self packets
end

ffi.cdef[[

void exit( int exit_code ); 

void *fopen(const char *path, const char *mode);

int fseek(void *stream, long offset, int whence);

long ftell(void *stream);

size_t fread(void *ptr, size_t size, size_t nmemb, void *stream);

size_t fwrite(const void *ptr, size_t size, size_t nmemb,
              void *stream);

]]

-- header=version,filenamelen,contentlen,from,seq; body=filename,content
function fillSendPacketBuf(filename, seq, contentlen)
   log("fill")
   local ptr = 0
   sendpacketbuf[ptr] = ffi.cast('uint8_t', 1)
   ptr = ptr + versionsize
   sendpacketbuf[ptr] = ffi.cast('uint16_t', #filename)
   ptr = ptr + filenamelensize
   sendpacketbuf[ptr] = ffi.cast('uint32_t', contentlen)
   ptr = ptr + contentlensize
   sendpacketbuf[ptr] = ffi.cast('uint32_t', self)
   ptr = ptr + fromsize
   sendpacketbuf[ptr] = ffi.cast('uint32_t', seq)
   ptr = ptr + seqsize
   -- set file name
   ffi.copy(sendpacketbuf + ptr, filename, #filename)
   -- content already set
end

-- header=version,filenamelen,contentlen,from,seq; body=filename,content
function makeRecvPacket()
   buf, len = nextPacketBuf()
   if buf == nil then
      return false
   end
   log("received")
   if len ~= packetlen then
      log("packet len "..tostring(len))
   end
   packet = {}
   local i = 0
   packet.version = buf[0]
   log('v '..tostring(packet.version))
   i = i + versionsize
   local filenamelen = ffi.cast('uint16_t', buf[i])
   i = i + filenamelensize
   local contentlen = ffi.cast('uint16_t', buf[i])
   i = i + contentlensize
   packet.from = ffi.cast('uint32_t', buf[i])
   i = i + fromsize
   packet.seq = ffi.cast('uint32_t', buf[i])
   i = i + seqsize
   packet.filename = ffi.string(buf + i, filenamelen)
   log(packet.filename)
   i = i + filenamelen
   packet.content = ffi.string(buf + i, contentlen)
   return true, packet
end
   
function sendFile(filename)
   local maxcontentlen = bodylen - #filename
   assert(maxcontentlen > 0)
   local sendfilebuf = sendpacketbuf + headerlen + #filename

   f = C.fopen(filename, "rb")
   assert(f ~= nil)
   local contentlen = C.fread(sendfilebuf, 1, maxcontentlen, f)
   local i = 0
   while contentlen > 0 do
      fillSendPacketBuf(filename, i, contentlen)
      ubc.peer_broadcast(client, sendpacketbuf, headerlen + #filename + contentlen)
      contentlen = C.fread(sendfilebuf, 1, maxcontentlen, f)
      i = i + 1
   end
end

function _run(hInstance, nCmdShow)
   jit.off(true, true) -- for debugging
   startNetwork()
   local callback = function(filename) 
      local fn = ffi.string(filename)
      log("selected "..fn)
      sendFile(fn)
   end

   ubc.set_log_fun(function(msg) log(ffi.string(msg)) end);

   ubc.on_file_selected(callback)
   ubc.start(hInstance, nCmdShow)
   while ubc.tick() ~= 0 do
      finished, file = tickNetwork()
      if finished then
	 log('finished', file)
      end
   end
end

function run(hInstance, cmdline, nCmdShow)
   log('run')
   if cmdline == 'cli' then
      log("client")
      cliOnly = true
   else
      log("server")
   end
   val, err = pcall(function() _run(hInstance, nCmdShow) end)
   log('bye')
   if not val then
      log(err)
   end
end