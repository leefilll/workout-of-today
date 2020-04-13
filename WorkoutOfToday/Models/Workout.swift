//
//  Workout.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class Workout: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var createdDateTime: Date = Date()
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var part: Int = Part.none.rawValue
    let sets = List<WorkoutSet>()
    var day = LinkingObjects(fromType: WorkoutsOfDay.self, property: "workouts")
    
    public var countOfSets: Int {
        return sets.count
    }
    
    public var totalVolume: Int {
        var total = 0
        self.sets.forEach { set in
            total += set.volume
        }
        return total
    }
    
    public var bestSet: WorkoutSet? {
        var volume = 0
        var bestSet: WorkoutSet?
        self.sets.forEach { set in
            if set.volume > volume {
                volume = set.volume
                bestSet = set
            }
        }
        return bestSet
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
