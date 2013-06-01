__declspec(dllexport) void* init(char *parentName);

__declspec(dllexport) int lock(void* whom);

__declspec(dllexport) int unlock(void* whom);

__declspec(dllexport) char* mapMemory(uint32_t memsize,
                                      char* memoryName, int isChild);
