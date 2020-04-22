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
//            self.workoutPartButton.part = workout?.part
//            self.workoutSetLabel.text = "\(workout?.numberOfSets ?? 0) set"
        }
    }

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var workoutNameLabel: UILabel!

    @IBOutlet weak var workoutPartButton: WorkoutPartButton!
    
//    @IBOutlet var unitLabels: [UILabel]!
    
//    @IBOutlet weak var workoutSetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.workout = nil
    }
    
    private func setup() {
        
        containerView.backgroundColor = .white
        
        workoutNameLabel.font = .smallBoldTitle
        workoutNameLabel.lineBreakMode = .byTruncatingTail
        workoutNameLabel.numberOfLines = 1
        
        workoutPartButton.isEnabled = false
        
//
//        unitLabels.forEach { label in
//            label.font = .description
//            label.textColor = .lightGray
//        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.setRoundedCorners(corners: [.topLeft, .topRight], radius: 10)

    }
}
