//
//  WorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class WorkoutHeaderView: BaseView, NibLoadable {
    
    var workout: Workout? {
        didSet {
            self.workoutNameLabel.text = workout?.name
            self.workoutPartButton.part = workout?.part
            self.workoutSetLabel.text = "\(workout?.numberOfSets ?? 0) set"
        }
    }

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var workoutNameLabel: UILabel!
    
    @IBOutlet weak var workoutPartButton: WorkoutPartButton!
    
    @IBOutlet weak var workoutSetLabel: UILabel!
    
    override func setup() {
        commonInit()
        backgroundColor = .clear
//        containerView.configureRoundedRect(withCorners: [.topLeft, .topRight], usingRadii: 10)
//        containerView.clipsToBounds = true
        
        workoutNameLabel.font = .smallBoldTitle
        workoutNameLabel.lineBreakMode = .byTruncatingTail
        workoutNameLabel.numberOfLines = 1
        
        workoutPartButton.isEnabled = false
        
        workoutSetLabel.font = .boldTitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.configureRoundedRect(withCorners: [.topLeft, .topRight], usingRadii: 10)
    }
}
