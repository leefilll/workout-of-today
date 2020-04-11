//
//  UViewController+Realm.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/09.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

extension Realm {
    func writeToRealm(_ execution: (() -> ())) {
        do {
            try self.write {
                execution()
            }
        } catch let error as NSError {
            fatalError("Error occurs: \(error)")
        }
    }
    
    func addToRealm(_ execution : (() -> ())? = nil, object: Object, update: Realm.UpdatePolicy) {
        do {
            try self.write {
                execution?()
                self.add(object, update: update)
            }
        } catch let error as NSError {
            fatalError("Error occurs: \(error)")
        }
    }
}
