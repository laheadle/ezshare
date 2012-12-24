local ffi = require("ffi")
local C = ffi.C

local ubc = ffi.load("udpbroadcast")

ffi.cdef[[


 __declspec(dllexport) void* peer_create(int isServer);

 __declspec(dllexport) int peer_broadcast(void* peerIn, char* msg, unsigned int size);

 __declspec(dllexport) void peer_destroy(void* p);

/* timeout is milliseconds */
 __declspec(dllexport) int peer_select(void* peerIn, int timeout);

 __declspec(dllexport) int peer_receive(void* peerIn, char* buf, int bufsize);

void exit( int exit_code ); 

]]

local CLIENT, SERVER = 0, 1

function run()
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
	    print("bad select");
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

run()