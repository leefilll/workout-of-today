//
//  CloseButton.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/28.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class CloseButton: BasicButton {
    override func setup() {
        setTitle("X", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldBody
        
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.height / 2
    }
}
