//
//  AddWorkoutFooterView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class WorkoutSetAddFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var workoutSetAddButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        containerView.backgroundColor = .white
        
        workoutSetAddButton.setTitle("세트 추가", for: .normal)
        workoutSetAddButton.setTitleColor(UIColor.tintColor, for: .normal)
        workoutSetAddButton.titleLabel?.font = .boldBody
        workoutSetAddButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        workoutSetAddButton.clipsToBounds = true
        workoutSetAddButton.layer.cornerRadius = 10
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.setRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
}
