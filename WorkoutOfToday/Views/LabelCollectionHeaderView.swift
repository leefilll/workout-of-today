//
//  FeedCollectionReusableView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class LabelCollectionHeaderView: UICollectionReusableView {
    
    weak var titleLabel: UILabel!
    
    weak var subtitleLabel : UILabel!
    
    var labelHorizontalConstant: CGFloat = 20 {
        didSet {
            setNeedsLayout()
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
        let titleLabel = UILabel()
        titleLabel.font = .smallBoldTitle
        titleLabel.textColor = .defaultTextColor
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = .boldBody
        subtitleLabel.isHidden = true
        subtitleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        self.titleLabel = titleLabel
        self.subtitleLabel = subtitleLabel
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(labelHorizontalConstant)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(labelHorizontalConstant)
            make.trailing.equalToSuperview().offset(-labelHorizontalConstant)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
