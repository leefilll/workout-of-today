//
//  Note.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/05.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class Note: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var content: String = ""
    @objc dynamic var created: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
