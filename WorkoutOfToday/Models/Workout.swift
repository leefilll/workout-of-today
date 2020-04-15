//
//  Workout.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class Workout: Object, NSCopying {
   
    
    @objc dynamic var name: String = ""
    @objc dynamic var createdDateTime: Date = Date()
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var part: Int = Part.none.rawValue
    @objc dynamic var equipment: Int = Equipment.none.rawValue
    @objc dynamic var note: String = ""
    let sets = List<WorkoutSet>()
    let day = LinkingObjects(fromType: WorkoutsOfDay.self, property: "workouts")
    
    public var numberOfSets: Int {
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
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Workout()
        copy.name = self.name
        copy.part = self.part
        copy.equipment = self.equipment
        copy.note = self.note
        for set in self.sets {
            let newSet = set.copy() as! WorkoutSet
            copy.sets.append(newSet)
        }
        return copy
    }
    
    func copy(from workout: Workout) {
        self.name = workout.name
        self.part = workout.part
        self.equipment = workout.equipment
        self.note = workout.note
        // TODO: Have to delete all origin set for mermory management
        self.sets.removeAll()
        DBHandler.shared.realm.delete(self.sets)
        for set in workout.sets {
            if let newSet = set.copy() as? WorkoutSet {
                self.sets.append(newSet)
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
