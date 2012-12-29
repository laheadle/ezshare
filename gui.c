#include <windows.h>
#include "gui.h"

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
void CreateMenubar(HWND);
void OpenDialog(HWND);

#define IDM_FILE_NEW 1

char* appname = "Easy Share";

void start(HINSTANCE hInstance, int nCmdShow)
{
  WNDCLASS wc = {0};
  wc.lpszClassName = appname;
  wc.hInstance     = hInstance ;
  wc.hbrBackground = GetSysColorBrush(COLOR_3DFACE);
  wc.lpfnWndProc   = WndProc ;
  wc.hCursor       = LoadCursor(0, IDC_ARROW);

  
  RegisterClass(&wc);
  CreateWindow( wc.lpszClassName, appname,
                WS_OVERLAPPEDWINDOW | WS_VISIBLE,
                150, 150, 265, 200, 0, 0, hInstance, 0);
}

int tick()
{
  MSG  msg;    
  if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
    DispatchMessage(&msg);
    if (msg.message == WM_QUIT)
      return 0;
  }
  return 1;
}

LRESULT CALLBACK WndProc( HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   
  switch(msg)  
  {
      case WM_CREATE:
        CreateWindowA("STATIC", "Nothing Selected",
		      WS_CHILD | WS_VISIBLE | SS_LEFT,
		      20, 20, 300, 50,
		      hwnd, (HMENU) 1, NULL, NULL);

	   CreateMenubar(hwnd);
	   break;

      case WM_COMMAND:
	   if (wParam==IDM_FILE_NEW) {
              OpenDialog(hwnd);
	    }
          break;

      case WM_DESTROY:
          PostQuitMessage(0);
          break;
  }
  return DefWindowProc(hwnd, msg, wParam, lParam);
}	

void CreateMenubar(HWND hwnd) {
  HMENU hMenubar;
  HMENU hMenu;

  hMenubar = CreateMenu();
  hMenu = CreateMenu();
  AppendMenu(hMenubar, MF_POPUP, (UINT_PTR)hMenu, TEXT("&File"));
  AppendMenu(hMenu, MF_STRING, IDM_FILE_NEW, TEXT("&Select File or Directory"));
  SetMenu(hwnd, hMenubar);
}

file_selected_fun fsel = NULL;

void on_file_selected (file_selected_fun fun)
{
  fsel = fun;
}

void OpenDialog(HWND hwnd) 
{
  OPENFILENAME ofn;
  TCHAR szFile[MAX_PATH];

 
  ZeroMemory(&ofn, sizeof(ofn));
  ofn.lStructSize = sizeof(ofn);
  ofn.lpstrFile = szFile;
  ofn.lpstrFile[0] = '\0';
  ofn.hwndOwner = hwnd;
  ofn.nMaxFile = sizeof(szFile);
  ofn.lpstrFilter = TEXT("All files(*.*)\0*.*\0");
  ofn.nFilterIndex = 1;
  ofn.lpstrInitialDir = NULL;
  ofn.lpstrFileTitle = NULL;
  ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;
  
  if(GetOpenFileName(&ofn))
    if (fsel != NULL) {
      MessageBoxA(hwnd, "yo", "yo", 0);
      (*fsel)(ofn.lpstrFile);
      MessageBoxA(hwnd, "yo2", "yo", 0);
    }
}

void sleep(int n)
{
  Sleep(n);
}
