//
//  Profile.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class Profile: Object {
    @objc dynamic var createdDateTime: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var height: Double = 0
    @objc dynamic fileprivate var id: String  = UUID().uuidString
    
    fileprivate let weights = List<Double>()
    
    func addNewWeight(_ newWeight: Double) {
//        DBHandler.shared.write {
//            weights.append(newWeight)
//        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
