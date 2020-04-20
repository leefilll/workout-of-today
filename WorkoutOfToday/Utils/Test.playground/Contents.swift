
import Foundation


class Test {
    var a = "a"
    var b = "b"
    var c = "CCCCC"
}

var A = Test()
var B = Test()

A.a = "A"
A.b = "B"
A.c = "SDFSDFSdf"
// A -> B c만 빼고

print(B.a)
print(B.b)
print(B.c)

print()
B.a = A.a
B.b = A.b
print()
print(B.a)
print(B.b)
print(B.c)
