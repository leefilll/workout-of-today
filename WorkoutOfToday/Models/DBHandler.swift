//
//  DBHandler.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

import RealmSwift

// MARK: Singletone Data Handler

class DBHandler {
    
    static let shared = DBHandler()
    
    private var _realm: Realm {
        do {
            return try Realm()
        } catch let error as NSError {
            // TODO: Error Handling
            fatalError("Error: \(error)")
        }
    }
    
    var realm: Realm {
        return _realm
    }
    
    private init() { }
    
    func write(_ execution: (() -> Void)) {
        do {
            try _realm.write {
                execution()
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func create(object: Object) {
        do {
            try _realm.write {
                _realm.add(object)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func createOrUpdate(object: Object) {
        do {
            try _realm.write {
                _realm.add(object, update: .all)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func delete(object: Object) {
        do {
            try _realm.write {
                _realm.delete(object)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func deleteWorkout(workout: Workout) {
        do {
            _realm.beginWrite()
            _realm.delete(workout.sets)
            _realm.delete(workout)
            try _realm.commitWrite()

//            try _realm.write {
//                _realm.delete(workout.sets)
//                _realm.delete(workout)
//                try _realm.commitWrite()
//            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
//
//    func deleteWorkoutsOfDay(workoutsOfDay: WorkoutsOfDay) {
//        do {
//            try _realm.write {
//                for workout in workoutsOfDay.workouts {
//                    deleteWorkout(workout: workout)
//                }
//                _realm.delete(workoutsOfDay)
//            }
//        } catch let error as NSError {
//            fatalError("Error: \(error)")
//        }
//    }
//
    func fetchObject<T: Object>(ofType type: T.Type, forPrimaryKey primaryKey: String) -> T? {
        return _realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func fetchObjects<T: Object>(ofType type: T.Type) -> Results<T> {
        return _realm.objects(type)
    }
    
    func fetchRecentObjects<T: Object>(ofType type: T.Type) -> [T] {
        let sortedObjects = _realm.objects(type).sorted(byKeyPath: "createdDateTime", ascending: false)
        
        var recentObjects: [T] = []
        for i in 0...20 {
            let object = sortedObjects[i]
            recentObjects.append(object)
        }
        
        return recentObjects
    }
}

// MARK: functions with calculate

extension DBHandler {
//    func fetcthMostFrequentWorkouts() -> [Dictionary<String, Int>.Element] {
//        let totalWorkouts = DBHandler.shared.fetchObjects(ofType: Workout.self)
//
//        let counts = workouts.reduce(into: [:]) { $0[$1.name, default: 0] += 1}
//        var sortedCounts = counts.sorted { $0.value > $1.value }
//        var mostFrequentWorkouts = [(String, Int)]()
//        for _ in 0..<5 {
//            let popped = sortedCounts.removeFirst()
//            mostFrequentWorkouts.append(popped)
//        }
//        return mostFrequentWorkouts
//    }
    
    private func fetcthPartsByCount(workouts: Results<Workout>) -> [Int] {
        let numberOfPart = Part.allCases.count
        var mostFrequentParts = [Int](repeating: 0, count: numberOfPart)
        
        workouts.forEach {
            mostFrequentParts[$0.part.rawValue] += 1
        }
        
        return mostFrequentParts
    }
    
    /// Note that index of this array means Part.rawValue
    func fetchWorkoutPartInPercentage() -> [Int] {
        let totalWorkouts = DBHandler.shared.fetchObjects(ofType: Workout.self)
        
        let mostFrequentParts = fetcthPartsByCount(workouts: totalWorkouts)
        let numberOfWorkouts = totalWorkouts.count
        
        if numberOfWorkouts == 0 {
            return [0]
        }
        
        var percentagesOfWorkoutPart = [Int](repeating: 0, count: mostFrequentParts.count)
        for (i, numberOfPart) in mostFrequentParts.enumerated() {
            percentagesOfWorkoutPart[i] = (numberOfPart * 100) / numberOfWorkouts
        }

        return percentagesOfWorkoutPart
    }
    
    /// fetch all workouts after period.rawvalue months before today
    private func fetchWorkoutsByPeriod(workoutName: String, period: Period) -> [Workout] {
        let beginningDate = period == .entire ?
            Date(timeIntervalSince1970: 0) : Date.now.dateFromMonths(-period.rawValue)
        let workouts = DBHandler.shared.fetchObjects(ofType: Workout.self).filter("_createdDateTime <= %@", beginningDate)
        let sortedWorkouts = workouts.sorted(byKeyPath: "_createdDateTime")
        return sortedWorkouts.filter { $0.name == workoutName }
    }
    
    func fetchWorkoutsByDate() -> [(date: Date, workouts: Results<Workout>)] {
        let workouts = DBHandler.shared.fetchObjects(ofType: Workout.self).sorted(byKeyPath: "created")
//            .filter { $0.totalVolume != 0 }

        let workoutsByDate = workouts
            .map { workout in
                return Calendar.current.startOfDay(for: workout.created)
            }
            .reduce([]) { dates, date in
                return dates.last == date ? dates : dates + [date]
            }
            .compactMap { startDate -> (date: Date, workouts: Results<Workout>)? in
                let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                let workouts = workouts.filter("(created >= %@) AND (created < %@)", startDate, endDate)
                return workouts.isEmpty ? nil : (date: startDate, workouts: workouts)
            }
        
        return workoutsByDate
    }
    
    func fetchWorkoutVolumes(workoutTemplate: WorkoutTemplate) -> [(date: Date, volume: Double)] {
        let selectedWorkouts = DBHandler.shared.fetchObjects(ofType: Workout.self)
            .filter("template == %@", workoutTemplate)
            .sorted(byKeyPath: "created")
        
        let volumesByDate = selectedWorkouts
            .map { workout in
                return (date: Calendar.current.startOfDay(for: workout.created), volume: workout.totalVolume)
            }
            .reduce([(date: Date, volume: Double)]()) { result, curr in
                if let last = result.last, last.date == curr.date {
                    var result = result
                    result[result.count - 1].volume += curr.volume
                    return result
                } else {
                    return result + [curr]
                }
            }
        
        return volumesByDate
    }
    
    
//
    // MARK: TODO - Onerm Calulator
//
//    func fetchWorkoutOnermByPeriod(workoutName: String, period: Period) -> [(date: Date, volume: Int)] {
//        let sortedWorkout = fetchWorkoutsByPeriod(workoutName: workoutName, period: period)
//
//        var onermByDate: [(date: Date, volume: Int)] = []
//        sortedWorkout.forEach {
//            let dateWithVolume = (date: $0.createdDateTime, volume: $0.totalVolume)
//            volumesByDate.append(dateWithVolume)
//        }
//
//        return volumesByDate
//
//    }
    
    /// Note that index 0 means Sunday, and 6 means Saturday
    func fetchWorkoutsOfDaysByWeekDays() -> [Int] {
//        let totalWorkoutsOfDay = DBHandler.shared.fetchObjects(ofType: WorkoutsOfDay.self)
//        var weekdaysCounts = [Int](repeating: 0, count: 7)
//        totalWorkoutsOfDay.forEach { workoutsOfDay in
//            let dateTime = workoutsOfDay.createdDateTime
//            let weekday = Calendar.current.component(.weekday, from: dateTime)
//            weekdaysCounts[weekday - 1] += 1
//        }
//        return weekdaysCounts
        return [1,1,1,1,1,1,1]
    }
}
