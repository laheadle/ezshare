local ffi = require 'ffi'

a = ffi.new('uint8_t[?]', 1, 5)

content = ffi.string(a, 0)
print (content=="")

