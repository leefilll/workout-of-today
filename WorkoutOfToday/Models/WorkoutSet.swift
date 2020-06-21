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
    
    @objc dynamic var weight: Double = 0
    @objc dynamic var reps: Int = 0
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
        return self.weight * Double(self.reps)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = WorkoutSet()
        copy.weight = self.weight
        copy.reps = self.reps
        copy.degree = self.degree
        return copy
    }
    
    override var description: String {
        if self.weight == 0 {
            return "\(self.reps)"
        } else {
            return "\(self.weight) kg X \(self.reps)"
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
