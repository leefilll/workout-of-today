//
//  CalendarTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class CalendarTableViewCell: BasicTableViewCell {
    
    var workoutSet: WorkoutSet? {
        didSet {
            fillLabels()
            setNeedsDisplay()
        }
    }
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    @IBOutlet weak var completeButton: BasicButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        
        countLabel.font = .smallBoldTitle
        countLabel.textColor = .lightGray
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.tintColor, for: .normal)
        completeButton.setTitle("취소", for: .selected)
        completeButton.setTitleColor(.white, for: .selected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countLabel.text = nil
        weightLabel.text = nil
        repsLabel.text = nil
    }
    
    private func fillLabels() {
        if let workoutSet = workoutSet {
            let weight = workoutSet.weight
            let reps = workoutSet.reps
            weightLabel.text = "\(weight)"
            repsLabel.text = "\(reps)"
        }
    }
}
