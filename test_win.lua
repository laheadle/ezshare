local ffi = require("ffi")
local C = ffi.C
local bit = require("bit")

local GDILib = ffi.load("gdi32.dll")
local Lib = ffi.load("kernel32.dll")
local User32Lib = ffi.load("User32.dll")
local Rpcrt4 = ffi.load("Rpcrt4.dll")

ffi.cdef[[

void *fopen(const char *filename, const char *mode);
 int fprintf(void * stream , const char * format , ...); 
int fflush ( void * stream );
void exit( int exit_code ); 

typedef unsigned int UINT;

  typedef char CHAR;
  typedef short SHORT;
  typedef long LONG;



  typedef wchar_t WCHAR;

  typedef WCHAR *PWCHAR,*LPWCH,*PWCH;
  typedef const WCHAR *LPCWCH,*PCWCH;
  typedef WCHAR *NWPSTR,*LPWSTR,*PWSTR;
  typedef PWSTR *PZPWSTR;
  typedef const PWSTR *PCZPWSTR;
  typedef WCHAR *LPUWSTR,*PUWSTR;
  typedef const WCHAR *LPCWSTR,*PCWSTR;
  typedef PCWSTR *PZPCWSTR;
  typedef const WCHAR *LPCUWSTR,*PCUWSTR;
  typedef CHAR *PCHAR,*LPCH,*PCH;
  typedef const CHAR *LPCCH,*PCCH;
  typedef CHAR *NPSTR,*LPSTR,*PSTR;
  typedef PSTR *PZPSTR;
  typedef const PSTR *PCZPSTR;
  typedef const CHAR *LPCSTR,*PCSTR;
  typedef PCSTR *PZPCSTR;

typedef unsigned long ULONG;
typedef ULONG *PULONG;
typedef unsigned short USHORT;
typedef USHORT *PUSHORT;
typedef unsigned char UCHAR;
typedef UCHAR *PUCHAR;
typedef char *PSZ;
typedef int WINBOOL;
       


typedef int BOOL;


typedef WINBOOL *PBOOL;
typedef WINBOOL *LPBOOL;
       


typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef unsigned long DWORD;
typedef float FLOAT;
typedef FLOAT *PFLOAT;
typedef BYTE *PBYTE;
typedef BYTE *LPBYTE;
typedef int *PINT;
typedef int *LPINT;
typedef WORD *PWORD;
typedef WORD *LPWORD;
typedef long *LPLONG;
typedef DWORD *PDWORD;
typedef DWORD *LPDWORD;
typedef void *LPVOID;

typedef void *HANDLE;

typedef const void *LPCVOID;

typedef int INT;
typedef unsigned int UINT;
typedef unsigned int *PUINT;
typedef int INT_PTR,*PINT_PTR;

typedef unsigned int UINT_PTR,*PUINT_PTR;

  typedef long LONG_PTR,*PLONG_PTR;
  typedef unsigned long ULONG_PTR,*PULONG_PTR;

typedef UINT_PTR WPARAM;
typedef LONG_PTR LPARAM;
typedef LONG_PTR LRESULT;


typedef WORD ATOM;

typedef HANDLE *SPHANDLE;
typedef HANDLE *LPHANDLE;
typedef HANDLE HGLOBAL;
typedef HANDLE HLOCAL;
typedef HANDLE GLOBALHANDLE;
typedef HANDLE LOCALHANDLE;

struct HWND__ { int unused; }; typedef struct HWND__ *HWND;
struct HHOOK__ { int unused; }; typedef struct HHOOK__ *HHOOK;





typedef WORD ATOM;

typedef HANDLE *SPHANDLE;
typedef HANDLE *LPHANDLE;
typedef HANDLE HGLOBAL;
typedef HANDLE HLOCAL;
typedef HANDLE GLOBALHANDLE;
typedef HANDLE LOCALHANDLE;





typedef int (__attribute__((__stdcall__)) *FARPROC)();
typedef int (__attribute__((__stdcall__)) *NEARPROC)();
typedef int (__attribute__((__stdcall__)) *PROC)();


typedef void *HGDIOBJ;

struct HKEY__ { int unused; }; typedef struct HKEY__ *HKEY;
typedef HKEY *PHKEY;

struct HACCEL__ { int unused; }; typedef struct HACCEL__ *HACCEL;
struct HBITMAP__ { int unused; }; typedef struct HBITMAP__ *HBITMAP;
struct HBRUSH__ { int unused; }; typedef struct HBRUSH__ *HBRUSH;
struct HCOLORSPACE__ { int unused; }; typedef struct HCOLORSPACE__ *HCOLORSPACE;
struct HDC__ { int unused; }; typedef struct HDC__ *HDC;
struct HGLRC__ { int unused; }; typedef struct HGLRC__ *HGLRC;
struct HDESK__ { int unused; }; typedef struct HDESK__ *HDESK;
struct HENHMETAFILE__ { int unused; }; typedef struct HENHMETAFILE__ *HENHMETAFILE;
struct HFONT__ { int unused; }; typedef struct HFONT__ *HFONT;
struct HICON__ { int unused; }; typedef struct HICON__ *HICON;
struct HMENU__ { int unused; }; typedef struct HMENU__ *HMENU;
struct HMETAFILE__ { int unused; }; typedef struct HMETAFILE__ *HMETAFILE;
struct HINSTANCE__ { int unused; }; typedef struct HINSTANCE__ *HINSTANCE;
typedef HINSTANCE HMODULE;
struct HPALETTE__ { int unused; }; typedef struct HPALETTE__ *HPALETTE;
struct HPEN__ { int unused; }; typedef struct HPEN__ *HPEN;

typedef int HFILE;
typedef HICON HCURSOR;
typedef DWORD COLORREF;
typedef DWORD *LPCOLORREF;

typedef struct tagRECT {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT,*PRECT,*NPRECT,*LPRECT;

typedef const RECT *LPCRECT;

typedef struct _RECTL {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECTL,*PRECTL,*LPRECTL;

typedef const RECTL *LPCRECTL;

typedef struct tagPOINT {
  LONG x;
  LONG y;
} POINT,*PPOINT,*NPPOINT,*LPPOINT;

typedef struct _POINTL {
  LONG x;
  LONG y;
} POINTL,*PPOINTL;

typedef struct tagSIZE {
  LONG cx;
  LONG cy;
} SIZE,*PSIZE,*LPSIZE;

typedef SIZE SIZEL;
typedef SIZE *PSIZEL,*LPSIZEL;

typedef struct tagPOINTS {
  SHORT x;
  SHORT y;
} POINTS,*PPOINTS,*LPPOINTS;

typedef struct _FILETIME {
  DWORD dwLowDateTime;
  DWORD dwHighDateTime;
} FILETIME,*PFILETIME,*LPFILETIME;



  typedef struct tagMSG {
    HWND hwnd;
    UINT message;
    WPARAM wParam;
    LPARAM lParam;
    DWORD time;
    POINT pt;
  } MSG,*PMSG,*NPMSG,*LPMSG;

  typedef LRESULT (__attribute__((__stdcall__)) *WNDPROC)(HWND,UINT,WPARAM,LPARAM);
HINSTANCE gethInstance();
void * GetModuleHandleA(void * app);

  typedef struct tagWNDCLASSA {
    UINT style;
    WNDPROC lpfnWndProc;
    int cbClsExtra;
    int cbWndExtra;
    HINSTANCE hInstance;
    HICON hIcon;
    HCURSOR hCursor;
    HBRUSH hbrBackground;
    LPCSTR lpszMenuName;
    LPCSTR lpszClassName;
  } WNDCLASSA,*PWNDCLASSA,*NPWNDCLASSA,*LPWNDCLASSA;

  typedef WNDCLASSA WNDCLASS;

  __attribute__((dllimport)) HBRUSH __attribute__((__stdcall__)) GetSysColorBrush(int nIndex);
  __attribute__((dllimport)) HCURSOR __attribute__((__stdcall__)) LoadCursorA(HINSTANCE hInstance,LPCSTR lpCursorName);
  __attribute__((dllimport)) HICON __attribute__((__stdcall__)) LoadIconA(HINSTANCE hInstance,LPCSTR lpIconName);
  __attribute__((dllimport)) ATOM __attribute__((__stdcall__)) RegisterClassA(const WNDCLASSA *lpWndClass);
  __attribute__((dllimport)) LRESULT __attribute__((__stdcall__)) DispatchMessageA(const MSG *lpMsg);
  __attribute__((dllimport)) WINBOOL __attribute__((__stdcall__)) ShowWindow(HWND hWnd,int nCmdShow);
  __attribute__((dllimport)) WINBOOL __attribute__((__stdcall__)) GetMessageA(LPMSG lpMsg,HWND hWnd,UINT wMsgFilterMin,UINT wMsgFilterMax);
  __attribute__((dllimport)) HWND __attribute__((__stdcall__)) CreateWindowExA(DWORD dwExStyle,LPCSTR lpClassName,LPCSTR lpWindowName,DWORD dwStyle,int X,int Y,int nWidth,int nHeight,HWND hWndParent,HMENU hMenu,HINSTANCE hInstance,LPVOID lpParam);
  __attribute__((dllimport)) WINBOOL __attribute__((__stdcall__)) UpdateWindow(HWND hWnd);
  __attribute__((dllimport)) void __attribute__((__stdcall__)) PostQuitMessage(int nExitCode);
  __attribute__((dllimport)) LRESULT __attribute__((__stdcall__)) DefWindowProcA(HWND hWnd,UINT Msg,WPARAM wParam,LPARAM lParam);
  __attribute__((dllimport)) DWORD __attribute__((__stdcall__)) GetLastError(void);
]]

local	CS_VREDRAW			= 0x0001
local	CS_HREDRAW			= 0x0002

local WS_OVERLAPPED = 0x00000000
local WS_POPUP = 0x80000000
local WS_CHILD = 0x40000000
local WS_MINIMIZE = 0x20000000
local WS_VISIBLE = 0x10000000
local WS_DISABLED = 0x08000000
local WS_CLIPSIBLINGS = 0x04000000
local WS_CLIPCHILDREN = 0x02000000
local WS_MAXIMIZE = 0x01000000
local WS_CAPTION = 0x00C00000
local WS_BORDER = 0x00800000
local WS_DLGFRAME = 0x00400000
local WS_VSCROLL = 0x00200000
local WS_HSCROLL = 0x00100000
local WS_SYSMENU = 0x00080000
local WS_THICKFRAME = 0x00040000
local WS_GROUP = 0x00020000
local WS_TABSTOP = 0x00010000
local WS_MINIMIZEBOX = 0x00020000
local WS_MAXIMIZEBOX = 0x00010000
local WS_TILED = WS_OVERLAPPED
local WS_ICONIC = WS_MINIMIZE
local WS_SIZEBOX = WS_THICKFRAME
local WS_OVERLAPPEDWINDOW = bit.bor(WS_OVERLAPPED, WS_CAPTION, WS_SYSMENU, WS_THICKFRAME, WS_MINIMIZEBOX, WS_MAXIMIZEBOX)
local WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW
local WS_POPUPWINDOW = bit.bor(WS_POPUP, WS_BORDER, WS_SYSMENU)
local WS_CHILDWINDOW = WS_CHILD

local WS_EX_WINDOWEDGE = 0x00000100

function makeIntResource(r)
   return ffi.cast("char *", ffi.cast("long", ffi.cast("short", r)))
end

local COLOR_3DFACE = 15
local IDI_APPLICATION = makeIntResource(32512)
local IDC_ARROW = makeIntResource(32512)

local ERROR = 1;
local INFO = 2;

local logfile = C.fopen("log.txt", "w");

function log(msg, lvl)
      C.fprintf(logfile, msg);
      C.fprintf(logfile, "\n");
      
end

--  typedef LRESULT (*WNDPROC)(HWND,UINT,WPARAM,LPARAM);
function wndproc(hwnd, msg, wParam, lParam) 
   log("wndproc "..tostring(msg))
   log("wndproc hwnd"..tostring(hwnd))
   if msg == 0x0002 then -- WM_DESTROY
      log("quit")
      C.PostQuitMessage(0)
      return 0
   end

   return C.DefWindowProcA(hwnd, msg, wParam, lParam)
end


function run(hInstance, nCmdShow)
   --hInstance = ffi.C.GetModuleHandleA(nil)
   log("handle "..tostring(hInstance))
   log("show ".. nCmdShow)
   local wc = ffi.new('WNDCLASS')
   wc.style         = bit.bor(CS_HREDRAW, CS_VREDRAW)
   wc.cbClsExtra    = 0
   wc.cbWndExtra    = 0
   wc.hInstance     = hInstance
   log("wc "..tostring(wc))
   wc.hbrBackground = C.GetSysColorBrush(COLOR_3DFACE)
   log("e")
   wc.lpszMenuName  = nil
   wc.lpfnWndProc   = wndproc
   log("wndproc "..tostring(wndproc))
   wc.hCursor       = C.LoadCursorA(NULL, IDC_ARROW)
   log("z")
   wc.hIcon         = C.LoadIconA(NULL, IDI_APPLICATION)
   wc.lpszClassName = "classs"

   log("c");
   C.RegisterClassA(wc);
   log("wc icon "..tostring(wc.hIcon));
   log("wc cursor "..tostring(wc.hCursor));
   log("wc bg "..tostring(wc.hbrBackground));
   hwnd = C.CreateWindowExA(0,
			    wc.lpszClassName, "Window",
			    bit.bor(WS_OVERLAPPEDWINDOW, WS_VISIBLE),
			    100, 100, 350, 250, nil, nil, hInstance, nil)
   log("hwnd "..tostring(hwnd))
   --local SW_SHOW = 5
   local show = C.ShowWindow(hwnd, nCmdShow)
   log("show "..tostring(show));
   C.UpdateWindow(hwnd);
   local msg = ffi.new('MSG')
   log("msg "..tostring(msg));

   v = C.GetMessageA(msg, hwnd, 0, 0)
   while v ~= -1 do
      if v == -1 then
	 log("error "..tostring(C.GetLastError()));
      else
	 log("dispatching "..tostring(v));
      end
      C.DispatchMessageA(msg);
      v = C.GetMessageA(msg, hwnd, 0, 0)
   end

   return msg.wParam;
end











