// To compile this file : typst compile --root .. .\test_utils.typ

#import "../src/utils.typ": first-letter-to-upper, pad

#assert(first-letter-to-upper("hello") == "Hello")
#assert(first-letter-to-upper("world") == "World")
#assert(pad(5, 2) == "05")
#assert(pad(123, 5) == "00123")
