//
//  TodayWorkoutTableHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/15.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutTableHeaderView: UIView {
    
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
//        self.backgroundColor = .white
        self.backgroundColor = .groupTableViewBackground
        self.dateLabel = UILabel()
        self.dateLabel.font = .smallBoldTitle
        
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(Inset.Cell.horizontalInset)
            make.bottom.equalToSuperview().offset(-5)
            make.top.greaterThanOrEqualTo(5)
        }
    }
}
