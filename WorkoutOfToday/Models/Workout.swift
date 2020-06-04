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
    @objc dynamic var template: WorkoutTemplate?
//    @objc dynamic var day: WorkoutsOfDay?
    @objc dynamic var created: Date = Date()
    let sets = List<WorkoutSet>()
//    let sets = LinkingObjects(fromType: WorkoutSet.self,
//                              property: "workout")
    
    public var name: String {
        return template?.name ?? ""
    }
    
    public var part: Part {
        return template?.part ?? .none
    }
    
    public var equipment: Equipment {
        return template?.equipment ?? .none
    }
       
    //    public var name: String {
    //        return _templates[0].name
    //    }
    
//    public var part: Part {
//        return _templates[0].part
//    }
//
//    public var equipment: Equipment {
//        return _templates[0].equipment
//    }
//
//    public var template: WorkoutTemplate {
//        return _templates[0]
//    }
//
//    public var day: WorkoutsOfDay {
//        return _days[0]
//    }
    
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
