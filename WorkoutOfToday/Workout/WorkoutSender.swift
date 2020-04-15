//
//  WorkoutSender.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

struct WorkoutSender {
    static func sendWorkoutPrimaryKeyIfExisted(workout: Workout?) -> String? {
        if let workout = workout {
            return workout.id
        } else {
            return nil
        }
    }
}
