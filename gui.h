
typedef void (*file_selected_fun)(char* filename);

__declspec(dllexport) void on_file_selected (file_selected_fun fun);

__declspec(dllexport) void start(HINSTANCE hInstance, int nCmdShow);
