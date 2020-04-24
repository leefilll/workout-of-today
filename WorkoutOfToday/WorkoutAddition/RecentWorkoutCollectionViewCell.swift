//
//  RecentWorkoutCollectionViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/16.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class RecentWorkoutCollectionViewCell: UICollectionViewCell {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
            self.nameLabel.text = self.workout?.name
            self.nameLabel.textColor = workout?.part.color
            self.nameLabel.backgroundColor = workout?.part.color.withAlphaComponent(0.1)
            self.setNeedsLayout()
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            animate(newValue)
        }
    }
    
    // MARK: View
    
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        nameLabel.sizeToFit()
        nameLabel.font = .boldBody
        nameLabel.textAlignment = .center
        nameLabel.clipsToBounds = true
    
        contentView.addSubview(self.nameLabel)
        
        self.nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.nameLabel.layer.cornerRadius = bounds.size.height * 0.30
    }
    
    private func animate(_ newValue: Bool) {
        UIView.animate(withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 0.4,
        initialSpringVelocity: 0.55,
        options: .curveEaseIn,
        animations: {
            if newValue == true {
                self.nameLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } else {
                self.nameLabel.transform = .identity
            }
        },
        completion: nil)
    }
    
//    override func layoutSubviews() {
     
}
