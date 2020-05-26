//
//  WorkoutPartCircleView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class WorkoutPartButton: BasicButton {
    
    var part: Part? {
        didSet {
            partDidUpdated()
        }
    }
    
    override func setup() {
        super.setup()
        part = Part.none
        setTitle("파트", for: .normal)
    }
    
    private func partDidUpdated() {
        if part == Part.none {
            backgroundColor = part?.color.withAlphaComponent(0.2)
        } else {
            backgroundColor = part?.color.withAlphaComponent(0.9)
        }
        setTitleColor(.white, for: .normal)
        setTitle(part?.description, for: .normal)
    }
    
    private func setupForEditMode() {
        setTitle("", for: .normal)
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

final class WorkoutEquipmentButton: BasicButton {
    
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
    
    private func equipmentDidUpdated() {
        backgroundColor = equipment?.color.withAlphaComponent(0.2)
        setTitleColor(equipment?.color, for: .normal)
        setTitle(equipment?.description, for: .normal)
    }
}


