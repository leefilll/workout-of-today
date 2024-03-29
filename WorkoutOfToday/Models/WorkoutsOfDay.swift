////
////  WorkoutsOfDay.swift
////  WorkoutOfToday
////
////  Created by Lee on 2020/04/07.
////  Copyright © 2020 Lee. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//final class WorkoutsOfDay: Object {
//    @objc dynamic var createdDateTime: Date = Date()
//    @objc dynamic var note: String = ""
//    // format: year-month-day
//    @objc dynamic var id: String  = DateFormatter.shared.keyStringFromNow
//    let workouts = List<Workout>()
////    let workouts = LinkingObjects(fromType: Workout.self, property: "day")
//    
//    var numberOfWorkouts: Int {
//        return workouts.count
//    }
//    
//    var yearString: String {
//        return DateFormatter.shared.string(of: .year, from: createdDateTime)
//    }
//    
//    var dateAndWeekdayString: String {
//        return DateFormatter.shared.string(from: createdDateTime)
//    }
//    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
