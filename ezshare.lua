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

void exit( int exit_code ); 

typedef void (*file_selected_fun)(char* filename);
void on_file_selected (file_selected_fun fun);

struct HINSTANCE__ { int unused; }; typedef struct HINSTANCE__ *HINSTANCE;
void start( HINSTANCE hInstance, int nCmdShow );

]]


--[[
udpmaxlen=65507
maxlen=1000 -- http://stackoverflow.com/questions/3292281/udp-sendto-and-recvfrom-max-buffer-size

versionsize=4
lengthsize=16
idsize = 64
opcodesize=8
flagsize=64
checksumsize=20
]]

local CLIENT, SERVER = 0, 1

function exit(v)
   ffi.C.exit(v)
end

logfile = io.open ("./log.txt", "w")

function log(msg, lvl)
   logfile:write(tostring(msg))
end

function fail(msg)
   log(tostring(msg).."\n")
   exit(1)
end

function start_network()
   if arg[1] == "cli" then
      cli = ubc.peer_create(CLIENT)
      msg = ffi.new('char[3]')
      ffi.copy(msg, "yo")
      ubc.peer_broadcast(cli, msg, 3)
   else
      srv = ubc.peer_create(SERVER)
      while true do
	 n = ubc.peer_select(srv, 25)
	 if n < 0 then
	    fail("bad select")
	 elseif n ~= 0 then
	    len = 256
	    buf = ffi.new("char[?]", len)
	    n = ubc.peer_receive(srv, buf, len)
	    print("\ngot "..ffi.string(buf, n));
	    ffi.C.exit(0)
	end
      end
   end
end

function _run(hInstance, nCmdShow)
   ubc.on_file_selected(function(filename) log("selected"..ffi.string(filename)) end)
   ubc.start(hInstance, nCmdShow)
end

function run(hInstance, nCmdShow)
   val, err = pcall(function() _run(hInstance, nCmdShow) end)

   if not val then
      log(err)
   end
end