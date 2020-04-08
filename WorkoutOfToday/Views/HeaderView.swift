//
//  HeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

class HeaderView: UIView {
    
    var titleLabel: UILabel!
    
    var dateLabel: UILabel!
    
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
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let fontSize = font.pointSize
        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        titleLabel.text = "오늘의 운동"
        addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.text = DateFormatter.sharedFormatter.dateString(from: Date())
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(dateLabel.snp.leading)
            make.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }
    }
}
