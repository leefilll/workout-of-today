//
//  Set.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class WorkoutSet: Object, NSCopying {
    
    @objc dynamic var weight: Double = 0    // weight
    @objc dynamic var reps: Int = 0         // reps / time
    @objc private dynamic var _degree: Degree.RawValue = Degree.none.rawValue
    @objc dynamic var id = UUID().uuidString
    
    public var degree: Degree {
        get {
            return Degree(rawValue: _degree) ?? .none
        }
        set(degree) {
            _degree = degree.rawValue
        }
    }
    
    public var rm: Double {
        // MARK: 1RM = W×(1+R/30) - Epley formal
        return weight * (1 + Double(reps) / 30)
    }
    
    public var volume: Double {
        if weight == 0 {
            return Double(reps)
        }
        return weight * Double(reps)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = WorkoutSet()
        copy.weight = weight
        copy.reps = reps
        copy.degree = degree
        return copy
    }
    
    override var description: String {
        if weight == 0 {
            return "\(reps)"
        } else {
            return "\(weight) kg X \(reps)"
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
