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

var arr = [1,2,3,4]
let s = arr.reduce(0) { (a, b) -> Result in
    return a += b
}

print(s)
let arraySum = arrData.reduce(0) { $0 + $1 }
