//
//  Set.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class WorkoutSet: Object {
    @objc dynamic var order: Int = 0
    @objc dynamic var weight: Int = 0
    @objc dynamic var reps: Int = 0
    @objc dynamic var id = UUID().uuidString
    let workout = LinkingObjects(fromType: Workout.self, property: "sets")
    
    var volume: Int {
        return self.weight * self.reps
    }
    
    override var description: String {
        return "\(self.weight) kg X \(self.reps)"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
