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
            self.backgroundColor = self.part?.color.withAlphaComponent(0.2)
            self.setTitleColor(self.part?.color, for: .normal)
            self.setTitle(self.part?.description, for: .normal)
        }
    }
        
    override func setup() {
        super.setup()
        self.part = Part.none
        self.setTitle("파트", for: .normal)
    }
}

final class WorkoutEquipmentButton: BaseButton {
    
    var equipment: Equipment? {
        didSet {
            self.backgroundColor = self.equipment?.color.withAlphaComponent(0.2)
            self.setTitleColor(self.equipment?.color, for: .normal)
            self.setTitle(self.equipment?.description, for: .normal)
        }
    }
        
    override func setup() {
        super.setup()
        self.equipment = Equipment.none
        self.setTitle("도구", for: .normal)
    }
}


