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
    
    var workout: Workout? {
        didSet {
            self.containerView.backgroundColor = Part(rawValue: self.workout?.part ?? 0)?.color
            self.nameLabel.text = self.workout?.name
            self.totalVolumeLabel.text = "\(self.workout?.totalVolume ?? 0) kg"
            self.totalSetLabel.text = "\(self.workout?.countOfSets ?? 0)"
            if let workout = self.workout, let bestSet = workout.bestSet {
                self.bestSetLabel.text = "최고: " + String(describing: bestSet)
            }
        }
    }

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
        self.selectionStyle = .none

        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 15
        
        
        self.nameLabel.font = .boldTitle
        
        self.totalVolumeLabel.font = .body
        
        self.totalSetLabel.font = .veryLargeTitle
        
        self.bestSetLabel.font = .subheadline
        
        self.setLabel.font = .body
        self.setLabel.text = "set"
        
    }
}
