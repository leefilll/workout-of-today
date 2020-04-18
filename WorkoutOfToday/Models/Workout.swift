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
    @objc private dynamic var _part: Int = Part.none.rawValue
    @objc private dynamic var _equipment: Int = Equipment.none.rawValue
    
    let sets = List<WorkoutSet>()
    let day = LinkingObjects(fromType: WorkoutsOfDay.self, property: "workouts")
    
    public var part: Part {
        get {
            return Part(rawValue: _part) ?? .none
        }
        set(part) {
            _part = part.rawValue
        }
    }
    
    public var equipment: Equipment {
        get {
            return Equipment(rawValue: _equipment) ?? .none
        }
        set(equipment) {
            _equipment = equipment.rawValue
        }
    }
    
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
        // TODO: Have to delete all origin set for mermory management
        DBHandler.shared.realm.delete(self.sets)
        self.sets.removeAll()
        
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
