//
//  CircularlLabelCollectionViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/07/12.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class CircularLabelCollectionViewCell: UICollectionViewCell {
    
    
    var content: Selectable? {
        didSet {
            nameLabel.text = content?.name
            if let part = content as? Part {
                containerView.backgroundColor = part.color.withAlphaComponent(0.5)
            }
            setNeedsLayout()
        }
    }
    
    // MARK: View

    weak var nameLabel: UILabel!

    weak var containerView: UIView!
    
    override var isSelected: Bool {
        willSet {
            if let part = content as? Part {
                if newValue {
                    containerView.backgroundColor = part.color
                } else {
                    containerView.backgroundColor = part.color.withAlphaComponent(0.5)
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
        let containerView = UIView(frame: CGRect(origin: .zero,
                                                 size: CGSize(width: 60, height: 60)))
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = containerView.bounds.height / 2
        contentView.addSubview(containerView)
        
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
}
