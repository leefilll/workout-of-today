import UIKit
import RealmSwift

class WOD: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    let workouts = List<W>()
//    let workouts = LinkingObjects(fromType: W.self, property: "day")
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class W: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var day: WOD?

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

let realm = try! Realm()
try! realm.write {
    realm.deleteAll()
}

let wod = WOD()
let w = W()
try! realm.write {
    realm.add(wod)
    realm.add(w)
    wod.workouts.append(w)
}


print(wod.workouts.first)

try! realm.write {
    realm.delete(w)
}

print(wod.workouts.first)

