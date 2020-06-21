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
    @objc dynamic var created: Date = Date()
    let sets = List<WorkoutSet>()
    
    public var name: String {
        return template?.name ?? ""
    }
    
    public var part: Part {
        return template?.part ?? .none
    }
    
    public var equipment: Equipment {
        return template?.equipment ?? .none
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
        guard let template = template else { return 0.0 }
        switch template.style {
            case .weightWithReps:
                return sets.reduce(0.0) { $0 + $1.volume }
            case .reps:
                return Double(numberOfSets)
            case .time:
                return 0.0
            default:
                return 0.0
        }
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
