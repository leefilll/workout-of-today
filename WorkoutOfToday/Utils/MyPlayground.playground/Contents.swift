import UIKit
import RealmSwift
//
//class WOD: Object {
//    @objc dynamic var id: String = UUID().uuidString
//    @objc dynamic var name: String = ""
//    let workouts = List<W>()
////    let workouts = LinkingObjects(fromType: W.self, property: "day")
//
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}

class W: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var created: Date = Date()
//    @objc dynamic var day: WOD?

//    let sets = LinkingObjects(fromType: S.self, property: "workout")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
//
//class S: Object {
//    @objc dynamic var id: String = UUID().uuidString
//    @objc dynamic var name: String = ""
//    @objc dynamic var workout: W?
//
//
//}

//let realm = try! Realm()
//try! realm.write {
//    realm.deleteAll()
//}
//
//let wod = WOD()
//let w = W()
//try! realm.write {
//    realm.add(wod)
//    realm.add(w)
//    wod.workouts.append(w)
//}
//
//
//print(wod.workouts.first)
//
//try! realm.write {
//    realm.delete(w)
//}
//
//print(wod.workouts.first)
//

extension Date {
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    func isSameDay(with date: Date) -> Bool {
        return self.compare(with: date, only: .day) == 0
    }
    
    func dateFromDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func dateFromHours(_ hour: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hour, to: self)!
    }
}

var totalWorkouts = [[W]]()

var date = Date().dateFromHours(-18)
print(Date().isSameDay(with: date))

var ws = [W]()

let w1 = W()
let w2 = W()
let w3 = W()
let w4 = W()
let w5 = W()
let w6 = W()
let w7 = W()

w1.created = Date().dateFromDays(-1)
w2.created = Date()
w3.created = Date()
w4.created = Date()
w5.created = Date()
w6.created = Date()
w7.created = Date().dateFromDays(2)

ws.append(w1)
ws.append(w2)
ws.append(w3)
ws.append(w4)
ws.append(w5)
ws.append(w6)
ws.append(w7)

//let sections = ws
//.map { workout in
//    // get start of a day
//    return Calendar.current.startOfDay(for: workout.created)
//}
//.reduce([]) { dates, date in
//    // unique sorted array of dates
//    return dates.last == date ? dates : dates + [date]
//}
//.compactMap { startDate -> (date: Date, workouts: Results<W>)? in
//    // create the end of current day
//    let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
//    // filter sorted results by a predicate matching current day
//    let workouts = ws.filter("(created >= %@) AND (created < %@)", startDate, endDate)
//    // return a section only if current day is non-empty
//    return workouts.isEmpty ? nil : (date: startDate, workouts: workouts)
//}


//
//_ = ws.reduce(into: [W]()) { result, workout in
//    if result.isEmpty {
//        result.append(workout)
//    } else if let first = result.first, first.created.isSameDay(with: workout.created) {
//        result.append(workout)
//    } else {
//        totalWorkouts.append(result)
//        result.removeAll()
//    }
//}
//
//for w in totalWorkouts {
//    print(w.count)
//}
//print(totalWorkouts)
