//
//  BaseCardView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/23.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BaseCardView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        
        clipsToBounds = true
        layer.cornerRadius = Size.cornerRadius
        setup()
    }
    
    func setup() {
//        fatalError("Setup functions did not overriden")
    }
}
