//
//  Set.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

class WorkoutSet: Object {
    @objc dynamic var order: Int16 = 0
    @objc dynamic var weight: Int16 = 0
    @objc dynamic var reps: Int16 = 0
    @objc dynamic var id = UUID().uuidString
    let workout = LinkingObjects(fromType: Workout.self, property: "sets")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
