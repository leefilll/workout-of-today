
import UIKit
import Foundation

class Test {
    
}

var a = Test()

func test<T>(_ type: T.Type) {
    print(String(describing: T.self))
}

print(test(Test.self))

