//
//  WorkoutPartCircleView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class WorkoutPartButton: BaseButton {
    
    var part: Part? {
        didSet {
            partDidUpdated()
//            setNeedsDisplay()
        }
    }
        
    override func setup() {
        super.setup()
        part = Part.none
        setTitle("파트", for: .normal)
    }
    
    fileprivate func partDidUpdated() {
        if part == Part.none {
            backgroundColor = part?.color.withAlphaComponent(0.2)
        } else {
            backgroundColor = part?.color.withAlphaComponent(0.9)
        }
        setTitleColor(.white, for: .normal)
        setTitle(part?.description, for: .normal)
    }
}

final class WorkoutEquipmentButton: BaseButton {
    
    var equipment: Equipment? {
        didSet {
            equipmentDidUpdated()
            setNeedsDisplay()
        }
    }
        
    override func setup() {
        super.setup()
        equipment = Equipment.none
        setTitle("도구", for: .normal)
    }
    
    fileprivate func equipmentDidUpdated() {
        backgroundColor = equipment?.color.withAlphaComponent(0.2)
        setTitleColor(equipment?.color, for: .normal)
        setTitle(equipment?.description, for: .normal)
    }
}


