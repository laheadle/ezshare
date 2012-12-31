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

--

function putb(buf, type, where, what)
   local bp = ffi.cast('uint8_t*', buf)
   local ptr = ffi.cast(type..'*', bp + where)
   ptr[0] = what
end

function getb(buf, type, where)
   local bp = ffi.cast('uint8_t*', buf)
   return ffi.cast(type..'*', bp + where)[0]
end

buf = ffi.new('uint8_t[?]', 512)

putb(buf, 'uint16_t', 0, 300)
assert(getb(buf, 'uint16_t', 0) == 300)

