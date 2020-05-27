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
    @objc dynamic var id = UUID().uuidString
    @objc private dynamic var _createdDateTime: Date = Date()
    private let _templates = LinkingObjects(fromType: WorkoutTemplate.self, property: "workouts")
    private let _days = LinkingObjects(fromType: WorkoutsOfDay.self, property: "workouts")
    
    let sets = List<WorkoutSet>()
    
    public var createdDateTime: Date {
        return _createdDateTime
    }
    
    public var name: String {
        return _templates[0].name
    }
    
    public var part: Part {
        return _templates[0].part
    }
    
    public var equipment: Equipment {
        return _templates[0].equipment
    }
    
    public var template: WorkoutTemplate {
        return _templates[0]
    }
    
    public var day: WorkoutsOfDay {
        return _days[0]
    }
    
    public var rm: Double {
        var rm: Double = 0
        sets.forEach {
            if rm < $0.rm {
                rm = $0.rm
            }
        }
        return rm
    }
    
    public var numberOfSets: Int {
        return sets.count
    }
    
    public var totalVolume: Double {
        var total = 0.0
        self.sets.forEach { set in
            total += set.volume
        }
        return total
    }
    
    public var bestSet: WorkoutSet? {
        var volume = 0.0
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
