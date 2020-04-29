//
//  RecentWorkoutCollectionViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/16.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class TodayWorkoutAddCollectionViewCell: UICollectionViewCell {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
            updateView()
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            animate(newValue)
        }
    }
    
    // MARK: View
    
    @IBOutlet weak var containerView: BaseCardView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var partButton: WorkoutPartButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        containerView.layer.cornerRadius = 15
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.textAlignment = .natural
        
        partButton.titleLabel?.font = .subheadline
        partButton.isEnabled = false
    }
    
    fileprivate func updateView() {
        containerView.backgroundColor = workout?.part.color
        
        nameLabel.sizeToFit()
        nameLabel.textColor = . white
        nameLabel.text = workout?.name
        
//        partButton.setTitleColor(workout?.part.color, for: .normal)
        partButton.part = workout?.part
    }
    
    private func animate(_ newValue: Bool) {
        UIView.animate(withDuration: 0.12,
        delay: 0,
        usingSpringWithDamping: 0.4,
        initialSpringVelocity: 0.55,
        options: .curveEaseIn,
        animations: {
            if newValue == true {
                self.containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } else {
                self.containerView.transform = .identity
            }
        },
        completion: nil)
    }
}
