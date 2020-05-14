//
//  FeedCollectionViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    
    // MARK: Model
    
    var content: Selectable? {
        didSet {
            nameLabel.text = content?.name
            if content is Workout {
                guard let workout = content as? Workout else { return }
                contentView.backgroundColor = workout.part.color
            } else {
                contentView.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
            }
            setNeedsLayout()
        }
    }
    
    // MARK: View
    
    var nameLabel: UILabel!
    
    override var isHighlighted: Bool {
        willSet {
            if content is Workout {
                guard let workout = content as? Workout else { return }
                if newValue == true {
                    contentView.backgroundColor = workout.part.color.withAlphaComponent(0.5)
                } else {
                    contentView.backgroundColor = workout.part.color
                }
            }
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if content is Workout {
            } else {
                if newValue == true {
                    contentView.backgroundColor = .tintColor
                } else {
                    contentView.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        nameLabel = UILabel()
        nameLabel.font = .smallBoldTitle
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
    
        contentView.addSubview(self.nameLabel)
        contentView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override func layoutSubviews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = bounds.size.height * 0.20
        nameLabel.sizeToFit()
    }
}
