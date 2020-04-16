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
    
    var realm: Realm {
        do {
            return try Realm()

        } catch let error as NSError {
            // TODO: Error Handling
            fatalError("Error: \(error)")
        }
    }
    
//    var realm = try! Realm()
    
    private init() { }
    
    func write(_ execution: (() -> Void)) {
        do {
            try self.realm.write {
                execution()
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func create(object: Object) {
        do {
            try self.realm.write {
                self.realm.add(object)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
    
    func createOrUpdate(object: Object) {
        do {
            try self.realm.write {
                self.realm.add(object, update: .all)
            }
        } catch let error as NSError {
            fatalError("Error: \(error)")
        }
    }
        
    func fetchObject<T: Object>(ofType type: T.Type, forPrimaryKey primaryKey: String) -> T? {
        return self.realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func fetchObjects<T: Object>(ofType type: T.Type) -> Results<T> {
        return self.realm.objects(type)
    }
    
    func fetchRecentObjects<T: Object>(ofType type: T.Type) -> Results<T> {
        let objects = self.realm.objects(type).sorted(byKeyPath: "createdDateTime", ascending: false)
        return objects
    }
}
