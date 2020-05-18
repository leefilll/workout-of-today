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
    
    var template: WorkoutTemplate? {
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
    
    @IBOutlet weak var containerView: BasicCardView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        containerView.layer.cornerRadius = 15
        nameLabel.font = .smallBoldTitle
        nameLabel.textAlignment = .natural
    }
    
    fileprivate func updateView() {
        containerView.backgroundColor = template?.part.color
        
        nameLabel.sizeToFit()
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = .white
        nameLabel.text = template?.name
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
