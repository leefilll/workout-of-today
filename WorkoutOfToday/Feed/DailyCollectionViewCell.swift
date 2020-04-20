//
//  FeedCollectionViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
            self.nameLabel.text = workout?.name
            self.contentView.backgroundColor = workout?.part.color
            self.setNeedsLayout()
        }
    }
    
    // MARK: View
    
    var nameLabel: UILabel!
    
    override var isHighlighted: Bool {
        willSet {
            if newValue == true {
                self.contentView.backgroundColor = workout?.part.color.withAlphaComponent(0.5)
            } else {
                self.contentView.backgroundColor = workout?.part.color
            }
        }
    }
    
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
        self.nameLabel.font = .smallBoldTitle
        self.nameLabel.textColor = .white
        self.nameLabel.textAlignment = .center
        self.nameLabel.numberOfLines = 1
        self.nameLabel.lineBreakMode = .byTruncatingTail
    
        self.contentView.addSubview(self.nameLabel)
        self.contentView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override func layoutSubviews() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = bounds.size.height * 0.20
        self.nameLabel.sizeToFit()
    }
}