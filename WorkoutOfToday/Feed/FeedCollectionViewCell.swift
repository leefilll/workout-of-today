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
            self.contentView.backgroundColor = UIColor.partColor(self.workout?.part ?? 0)
            self.setNeedsLayout()
        }
    }
    
    // MARK: View
    
    var nameLabel: UILabel!
    
    override var isHighlighted: Bool {
        willSet {
            if newValue == true {
                self.contentView.backgroundColor = UIColor.partColor(self.workout?.part ?? 0).withAlphaComponent(0.5)
            } else {
                self.contentView.backgroundColor = UIColor.partColor(self.workout?.part ?? 0)
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
    }
    
    override func layoutSubviews() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = bounds.size.height * 0.20
        self.nameLabel.sizeToFit()
        self.nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
