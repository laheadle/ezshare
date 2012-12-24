
 __declspec(dllexport) void* peer_create(int isServer);

 __declspec(dllexport) int peer_broadcast(void* peerIn, char* msg, unsigned int size);

 __declspec(dllexport) void peer_destroy(void* p);

/* timeout is milliseconds */
 __declspec(dllexport) int peer_select(void* peerIn, int timeout);

 __declspec(dllexport) int peer_receive(void* peerIn, char* buf, int bufsize);
