#include <stdio.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include <windows.h>

int WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPSTR lpCmdLine,int nCmdShow)
{
  lua_State* L = luaL_newstate();
  luaL_openlibs(L);
  luaL_dostring(L, "require \"ezshare\"");
  lua_getfield(L, LUA_GLOBALSINDEX, "run");
  lua_pushlightuserdata (L, hInstance);
  lua_pushlstring(L, lpCmdLine, strlen(lpCmdLine));
  lua_pushinteger(L, nCmdShow);
  lua_call(L, 3, 1); 
  return lua_tointeger(L, -1);
}

