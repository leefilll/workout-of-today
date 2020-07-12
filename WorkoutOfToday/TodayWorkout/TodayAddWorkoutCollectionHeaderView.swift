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

    private func setup() {
        titleLabel = UILabel()
        titleLabel.font = .boldBody
        titleLabel.textColor = .defaultTextColor
        titleLabel.baselineAdjustment = .alignBaselines
        
        let divideLineView = UIView()
        divideLineView.backgroundColor = .weakGray
        divideLineView.layer.cornerRadius = 5
        
        addSubview(titleLabel)
        addSubview(divideLineView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        divideLineView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(1)
        }
    }
}
