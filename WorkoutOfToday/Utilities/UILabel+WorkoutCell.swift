//
//  UILabel+WorkoutCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UILabel {
    static func workoutCellLabel(font: UIFont, color: UIColor? = .white) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.sizeToFit()
        return label
    }
    
    static func workoutSetUnitLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.subheadline
        label.text = text
        return label
    }
}
