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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        
        countLabel.font = .smallBoldTitle
        countLabel.textColor = .lightGray
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
            let weightString = weight.isInt
                ? String(format: "%d", Int(weight))
                : String(format: ".1f%", weight)
            weightLabel.text = weightString
            repsLabel.text = "\(reps)"
        }
    }
}
