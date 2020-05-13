
import UIKit
import Foundation


var cal = Calendar.current
extension Date {
    func dateFromDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}


var date = Date().dateFromDays(-3)

var dc = cal.dateComponents([.weekday], from: date)

var df = DateFormatter()

let weekdaysCounts = [Int](repeating: 0, count: 6)
print(weekdaysCounts)

