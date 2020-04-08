//
//  Workout.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Workout: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var createdDateTime: Date = Date()
    @objc dynamic var id = UUID().uuidString
    let sets = List<WorkoutSet>()
    var day = LinkingObjects(fromType: WorkoutsOfDay.self, property: "workouts")
    
    public var countOfSets: Int {
        return sets.count
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
