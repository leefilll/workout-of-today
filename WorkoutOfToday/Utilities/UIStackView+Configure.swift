
//
//  UIStackView+SetTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/09.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func configureForWorkoutSet() {
        self.axis = .horizontal
        self.spacing = 10
        self.distribution = .fillEqually
    }
}

