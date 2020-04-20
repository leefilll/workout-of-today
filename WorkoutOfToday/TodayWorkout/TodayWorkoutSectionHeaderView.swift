//
//  WorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutSectionHeaderView: UITableViewHeaderFooterView, NibLoadable {
    
    var workout: Workout? {
        didSet {
            self.workoutNameLabel.text = workout?.name
            self.workoutPartButton.part = workout?.part
//            self.workoutSetLabel.text = "\(workout?.numberOfSets ?? 0) set"
        }
    }

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var workoutNameLabel: UILabel!

    @IBOutlet weak var workoutPartButton: WorkoutPartButton!

//    @IBOutlet weak var workoutSetLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        commonInit()
        
        containerView.backgroundColor = .white
        
        workoutNameLabel.font = .smallBoldTitle
        workoutNameLabel.lineBreakMode = .byTruncatingTail
        workoutNameLabel.numberOfLines = 1
        
        workoutPartButton.isEnabled = false
        
//        workoutSetLabel.font = .boldTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.setRoundedCorners(corners: [.topLeft, .topRight], radius: 10)

    }

}
