//
//  HeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class HeaderView: UIView {
    
    var titleLabel: UILabel!
    
    var dateLabel: UILabel!
    
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
        self.titleLabel.font = UIFont.largeTitle
        self.titleLabel.text = "오늘의 운동"
        self.addSubview(self.titleLabel)
        
        self.dateLabel = UILabel()
        self.dateLabel.text = DateFormatter.sharedFormatter.dateString(from: Date())
        self.dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.addSubview(dateLabel)
        
        self.dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.dateLabel.snp.leading)
            make.bottom.equalTo(self.dateLabel.snp.top).offset(-10)
        }
    }
}
