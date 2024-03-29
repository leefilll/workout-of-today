//
//  TodayWorkoutTableHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/15.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BasicSectionHeaderView: UITableViewHeaderFooterView {
    
    var label: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        label = UILabel()
        label.font = .smallBoldTitle
        
        addSubview(self.label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(Inset.Cell.horizontalInset)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(0)
        }
    }
}
