//
//  TodayAddWorkoutCollectionHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayAddWorkoutCollectionHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    fileprivate func setup() {
        titleLabel = UILabel()
        titleLabel.font = .subheadline
        titleLabel.textColor = .defaultTextColor
        titleLabel.baselineAdjustment = .alignBaselines
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
