#include <stdio.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include <windows.h>

static HINSTANCE hi;

HINSTANCE gethInstance() { return hi; }

int WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPSTR lpCmdLine,int nCmdShow)
{
  lua_State* L = luaL_newstate();
  hi = hInstance;
  luaL_openlibs(L);
  luaL_dostring(L, "require \"tst\"");
  /*  lua_getfield(L, LUA_GLOBALSINDEX, "tstIt");
  lua_pushinteger(L, hInstance);
  lua_call(L, 1, 0); 
  return 0; */
}

