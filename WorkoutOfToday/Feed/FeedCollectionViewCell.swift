//
//  FeedCollectionViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
            self.nameLabel.text = self.workout?.name
            self.backgroundColor = UIColor.partColor(self.workout?.part ?? 0)
            self.setNeedsLayout()
        }
    }
    
    // MARK: View
    
//    var containerView: UIView!
    
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
        self.clipsToBounds = true
        
        
        self.nameLabel = UILabel()
        self.nameLabel.font = .boldTitle
        self.nameLabel.textColor = .white
        self.nameLabel.textAlignment = .center
        
        self.addSubview(self.nameLabel)
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = bounds.size.height * 0.20
        self.nameLabel.sizeToFit()
        self.nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
