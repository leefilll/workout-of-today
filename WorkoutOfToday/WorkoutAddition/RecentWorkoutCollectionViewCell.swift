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
            self.nameLabel.textColor = UIColor.partColor(self.workout?.part ?? 0)
            self.nameLabel.backgroundColor = UIColor.partColor(self.workout?.part ?? 0).withAlphaComponent(0.1)
            self.setNeedsLayout()
        }
    }
    
    // MARK: View
    
    var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.nameLabel = UILabel()
        self.nameLabel.font = .boldBody
        self.nameLabel.textAlignment = .center
//        self.nameLabel.layer.borderWidth = 1
        self.nameLabel.clipsToBounds = true
        
        self.nameLabel.textColor = .lightGray
    
        self.addSubview(self.nameLabel)
    }
    
    override func layoutSubviews() {
        self.nameLabel.sizeToFit()
        self.nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.nameLabel.layer.cornerRadius = bounds.size.height * 0.30
    }
}
