//
//  WorkoutsOfTodayTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/11.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class WorkoutTableViewCell: BasicTableViewCell {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
//            self.containerView.backgroundColor = Part(rawValue: self.workout?.part ?? 0)?.color
            self.backgroundColor = .groupTableViewBackground
            self.containerView.backgroundColor = .white
            self.nameLabel.text = self.workout?.name
            self.workoutPartButton.part = self.workout?.part
            self.totalVolumeLabel.text = "\(self.workout?.totalVolume ?? 0) kg"
            self.totalSetLabel.text = "\(self.workout?.numberOfSets ?? 0)"
            if let workout = self.workout, let bestSet = workout.bestSet {
                self.bestSetLabel.text = "BEST: " + String(describing: bestSet)
            }
        }
    }
    
    // MARK: View

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var workoutPartButton: WorkoutPartButton!
    
    @IBOutlet weak var totalVolumeLabel: UILabel!
    
    @IBOutlet weak var bestSetLabel: UILabel!
    
    @IBOutlet weak var totalSetLabel: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            self.containerView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        } else {
            self.containerView.backgroundColor = UIColor.white
        }
    }
    
    override func setup() {
        self.isAccessibilityElement = false
        self.selectionStyle = .none

        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 10
        
        self.nameLabel.font = .smallBoldTitle
        self.nameLabel.lineBreakMode = .byTruncatingTail
        self.nameLabel.numberOfLines = 1
        
        self.totalVolumeLabel.font = .description
        self.totalVolumeLabel.textColor = .lightGray
        
        self.totalSetLabel.font = .veryLargeTitle
        self.totalSetLabel.sizeToFit()
        
        self.bestSetLabel.font = .description
        self.bestSetLabel.text = ""
        
        self.setLabel.font = .smallBoldTitle
        self.setLabel.text = "set"
        self.setLabel.sizeToFit()
    }
}
