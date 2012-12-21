local ffi = require("ffi")

--[[ POSIX
print(ffi.os)
]]

--[[ cant find the dll
ffi.os = "Windows"
local user32 = ffi.load("User32")
--]]

--[[ this works
local user32 = ffi.load("User32.dll")
print (user32)
--]]

--[[ works
require("WTypes")
--print(UUIDFromString("abcde"))
--]]


local usr = require "user32_ffi"
local User32Lib = ffi.load("User32.dll");
local C = ffi.C

--[[works
C.MessageBoxA(nil, "Blah blah...", "My Windows app!", usr.MB_SETFOREGROUND );

]]

ffi.cdef[[
HINSTANCE gethInstance() { return hi; }
]]

local COLOR_3DFACE = 15
local IDI_APPLICATION = 32512

function run()
   C.gethInstance()
   C.MessageBoxA(nil, "l", "My Windows app!", usr.MB_SETFOREGROUND );
--[[
   local msg = ffi.typeof('MSG')()
   local wc = ffi.typeof('WNDCLASSA')()
   wc.style         = usr.CS_HREDRAW | usr.CS_VREDRAW;
   wc.cbClsExtra    = 0;
   wc.cbWndExtra    = 0;
   wc.hInstance     = C.gethInstance();
   C.MessageBoxA(nil, "".. hInstance, "My Windows app!", usr.MB_SETFOREGROUND );
   wc.hbrBackground = ffi.C.GetSysColorBrush(usr.COLOR_3DFACE);
   wc.lpszMenuName  = NULL;
   wc.lpfnWndProc   = WndProc;
   wc.hCursor       = ffi.C.LoadCursor(NULL, IDC_ARROW);
   wc.hIcon         = ffi.C.LoadIcon(NULL, IDI_APPLICATION);
   ]]   
end


run()