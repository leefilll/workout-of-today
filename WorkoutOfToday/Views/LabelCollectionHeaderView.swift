//
//  FeedCollectionReusableView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class LabelCollectionHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel!
    
    var titleLabelLeadingConstant: CGFloat = 20 {
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
        self.titleLabel = UILabel()
        self.titleLabel.font = .smallBoldTitle
        self.addSubview(self.titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(titleLabelLeadingConstant)
            make.bottom.equalToSuperview().offset(-6)
        }
    }
}
