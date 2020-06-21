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
            switch content {
                case let workout as Workout:
                    containerView.backgroundColor = workout.template?.part.color
                case let template as WorkoutTemplate:
                    containerView.backgroundColor = template.part.color
                default:
                    contentView.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
            }
            setNeedsLayout()
        }
    }
    
    // MARK: View
    
    weak var nameLabel: UILabel!
    
    weak var containerView: BasicCardView!
    
    override var isHighlighted: Bool {
        willSet {
            if content is Workout || content is WorkoutTemplate {
                animate(newValue)
            }
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if content is Part || content is Style {
                select(newValue)
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
        let containerView = BasicCardView()
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(3)
            make.trailing.bottom.equalToSuperview().offset(-3)
        }
        
        let nameLabel = UILabel()
        nameLabel.font = .smallBoldTitle
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = bounds.size.height * 0.20
        
        self.containerView = containerView
        self.nameLabel = nameLabel
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
    
    private func select(_ newValue: Bool) {
        if newValue {
            contentView.backgroundColor = UIColor.tintColor
        } else {
            contentView.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
        }
    }
}
