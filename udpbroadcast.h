
typedef void* tpeer;

__declspec(dllexport) tpeer peer_create(int isServer);

__declspec(dllexport) int peer_broadcast(tpeer peerIn, char* msg, unsigned int size);

__declspec(dllexport) void peer_destroy(tpeer p);

/* timeout is milliseconds */
__declspec(dllexport) int peer_select(tpeer peerIn, int timeout);

__declspec(dllexport) int peer_receive(tpeer peerIn, char* buf, int bufsize);

typedef void (*log_fun)(const char* msg);

__declspec(dllexport) void set_log_fun(log_fun fun);
