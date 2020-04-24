
import UIKit
import Foundation


enum Test: Int, CaseIterable {
    case a = 0
    case b, c, d, e, f, g
}

var ls = [Test.a, Test.b, Test.a, Test.c]
var res = [Int](repeating: 0, count: Test.allCases.count)



ls.forEach { res[$0.rawValue] += 1 }
res
