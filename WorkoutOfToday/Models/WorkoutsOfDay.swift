//
//  WorkoutsOfDay.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

class WorkoutsOfDay: Object {
    @objc dynamic var createdDateTime = Date.now
    @objc dynamic var id: String  = DateFormatter.sharedFormatter.string(from: Date.now.startOfDay!)
    
    let workouts = List<Workout>()
    
    var countOfWorkouts: Int {
        return workouts.count
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
