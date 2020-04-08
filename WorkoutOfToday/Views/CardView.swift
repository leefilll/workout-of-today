//
//  CardView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dropShadow()
        configureRoundedRect(usingRadius: 20)
    }
}
