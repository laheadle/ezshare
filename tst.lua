local ffi = require 'ffi'

a = ffi.new('uint8_t[?]', 1, 5)

content = ffi.string(a, 0)
assert (content=="")

--

a = {}
a.b = nil
size = 0
for i,j in pairs(a) do
   size = size + 1
end
assert(size == 0)

--

a = { c=5 }
assert(type(pairs(a)) == 'function')

