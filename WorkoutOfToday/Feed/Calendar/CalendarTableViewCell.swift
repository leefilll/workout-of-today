//
//  CalendarTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SwiftIcons

class CalendarTableViewCell: BasicTableViewCell {
    
    var workoutSet: WorkoutSet? {
        didSet {
            fillLabels()
            setNeedsDisplay()
        }
    }
    
    var style: Style? {
        didSet {
            setStyle()
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var repsLabel: UILabel!
    
    @IBOutlet weak var divideLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        
        divideLineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        divideLineView.layer.cornerRadius = 2
        
        weightLabel.font = .smallestBoldTitle
        weightLabel.textColor = .defaultTextColor
        repsLabel.font = .smallestBoldTitle
        repsLabel.textColor = .defaultTextColor
        
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
                : String(format: "%.1f", weight)
            weightLabel.text = weightString + " kg"
            repsLabel.text = "\(reps)회"
        }
    }
    
    private func setStyle() {
        guard let style = style else { return }
        switch style {
            case .weightWithReps:
                weightLabel.isHidden = false
                repsLabel.isHidden = false
            case .reps, .time:
                weightLabel.isHidden = true
                repsLabel.isHidden = false
            default:
                break
        }
    }
}
