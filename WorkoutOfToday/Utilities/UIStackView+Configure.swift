
//
//  UIStackView+SetTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/09.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIStackView {
    
    // |-first-[--subView-subView--]-|
    convenience init(firstView: UIView, subViews: [UIView]) {
        self.init()
        self.addArrangedSubview(firstView)
        firstView.frame.size.width = 30
        
        let subViews = UIStackView(arrangedSubviews: subViews)
        subViews.axis = .horizontal
        subViews.spacing = 10
        subViews.distribution = .fillEqually
//        subViews.alignment = .center
        
        self.addArrangedSubview(subViews)
        self.axis = .horizontal
        self.spacing = 20
        self.alignment = .center
    }
    
    func configureForWorkout(spacing: CGFloat,
                             alignment: UIStackView.Alignment,
                             axis: NSLayoutConstraint.Axis = .horizontal) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
    }
}

