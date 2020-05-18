
import UIKit
import Foundation

var a = [1,2,3]
a.forEach {
    if $0 == 2 { return }
    print($0)
}
print(a)
