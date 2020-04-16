//
//  WorkoutsOfTodayTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/11.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class WorkoutTableViewCell: UITableViewCell {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
//            self.containerView.backgroundColor = Part(rawValue: self.workout?.part ?? 0)?.color
            self.backgroundColor = .groupTableViewBackground
            self.containerView.backgroundColor = .white
            self.nameLabel.text = self.workout?.name
            
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
    
    @IBOutlet weak var totalVolumeLabel: UILabel!
    
    @IBOutlet weak var totalSetLabel: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var bestSetLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.setup()
    }
    
     private func commonInit() {
           let name = String(describing: type(of: self))
           guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return }
           guard let view = loadedNib.first as? UIView else { return }
           view.frame = self.bounds
           view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.addSubview(view)
       }
    
    private func setup() {
        self.isAccessibilityElement = false
        self.selectionStyle = .none

        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 10
        
        self.nameLabel.font = .smallBoldTitle
        self.nameLabel.lineBreakMode = .byTruncatingTail
        self.nameLabel.numberOfLines = 1
        
        self.totalVolumeLabel.font = .description
        
        self.totalSetLabel.font = .veryLargeTitle
        self.totalSetLabel.sizeToFit()
        
        self.bestSetLabel.font = .description
        self.bestSetLabel.text = ""
        
        self.setLabel.font = .smallBoldTitle
        self.setLabel.text = "set"
        self.setLabel.sizeToFit()
    }
}
