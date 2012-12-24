local ffi = require("ffi")
local C = ffi.C

local save_hi = ffi.load("save_hi")

ffi.cdef[[
 __stdcall int get_hi();
]]

function run()
   print("checking");
   print(tostring(save_hi.get_hi()))
   print("did not crash");
end


run()