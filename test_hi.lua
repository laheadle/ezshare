local ffi = require("ffi")
local C = ffi.C

ffi.cdef[[
int get_hi();
]]

function run()
   print("checking");
   print(C.get_hi())
   print("did not crash");
end


run()