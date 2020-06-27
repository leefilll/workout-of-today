//
//  WorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutSectionHeaderView: UITableViewHeaderFooterView, NibLoadable {
    
    var template: WorkoutTemplate? {
        didSet {
            workoutNameLabel.text = template?.name
            workoutPartButton.part = template?.part
            setStyle()
        }
    }
    
    var isDetailView: Bool = false {
        willSet {
            topStackView.isHidden = newValue
        }
    }

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var workoutNameLabel: UILabel!

    @IBOutlet weak var workoutPartButton: WorkoutPartButton!
    
    @IBOutlet weak var workoutEquipmentButton: WorkoutEquipmentButton!
    
    @IBOutlet var unitLabels: [UILabel]!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        template = nil
    }
    
    private func setup() {
        containerView.backgroundColor = .white
        
        workoutNameLabel.font = .smallBoldTitle
        workoutNameLabel.lineBreakMode = .byTruncatingTail
        workoutNameLabel.numberOfLines = 1
        
        workoutPartButton.isEnabled = false
        workoutPartButton.setTitleColor(.white, for: .disabled)

        unitLabels.forEach { label in
            label.font = .description
            label.textColor = .lightGray
        }
    }
    private func setStyle() {
        guard let template = template else { return }
        switch template.style {
            case .weightWithReps:
                weightLabel.isHidden = false
                weightLabel.text = "kg"
                repsLabel.isHidden = false
                repsLabel.text = "reps"
            case .time:
                weightLabel.isHidden = true
                repsLabel.isHidden = false
                repsLabel.text = "min"
            case .reps:
                weightLabel.isHidden = true
                repsLabel.isHidden = false
                repsLabel.text = "reps"
            default: break
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.setRoundedCorners(corners: [.topLeft, .topRight], radius: 10)
    }
}
