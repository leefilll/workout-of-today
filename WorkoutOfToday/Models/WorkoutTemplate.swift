//
//  WorkoutTemplate.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class WorkoutTemplate: Object {
    @objc private dynamic var _id = UUID().uuidString
    @objc private dynamic var _name: String = ""
    @objc private dynamic var _part: Int = Part.none.rawValue
    @objc private dynamic var _style: Int = Style.none.rawValue
    @objc private dynamic var _equipment: Int = Equipment.none.rawValue
    let workouts = List<Workout>()
    
    public var name: String {
        get {
            return _name
        }
        set(name) {
            _name = name
        }
    }
    
    public var part: Part {
        get {
            return Part(rawValue: _part) ?? .none
        }
        set(part) {
            _part = part.rawValue
        }
    }
    
    public var style: Style {
        get {
            return Style(rawValue: _style) ?? .none
        }
        set(style) {
            _style = style.rawValue
        }
    }
    
    public var equipment: Equipment {
        get {
            return Equipment(rawValue: _equipment) ?? .none
        }
        set(equipment) {
            _equipment = equipment.rawValue
        }
    }
    
    public var numberOfWorkout: Int {
        return workouts.count
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
