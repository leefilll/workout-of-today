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
            try _realm.write {
                _realm.delete(workout.sets)
                _realm.delete(workout)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func deleteWorkoutsOfDay(workoutsOfDay: WorkoutsOfDay) {
        do {
            try _realm.write {
                for workout in workoutsOfDay.workouts {
                    deleteWorkout(workout: workout)
                }
                _realm.delete(workoutsOfDay)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func fetchObject<T: Object>(ofType type: T.Type, forPrimaryKey primaryKey: String) -> T? {
        return _realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func fetchObjects<T: Object>(ofType type: T.Type) -> Results<T> {
        return _realm.objects(type)
    }
    
    func fetchRecentObjects<T: Object>(ofType type: T.Type) -> Results<T> {
        return _realm.objects(type).sorted(byKeyPath: "createdDateTime", ascending: false)
    }
}
