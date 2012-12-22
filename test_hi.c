#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

int main()
{
  lua_State* L = luaL_newstate();
  luaL_openlibs(L);
  luaL_dostring(L, "require \"test_hi\"");
  return 0;
}

