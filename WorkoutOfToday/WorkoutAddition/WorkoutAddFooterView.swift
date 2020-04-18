//
//  AddWorkoutFooterView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class WorkoutAddFooterView: BaseView {
    
    deinit {
        print("vc deinit - footerView")
        print("vc deinit - footerView")
        print("vc deinit - footerView")
        print("vc deinit - footerView")
        print("vc deinit - footerView")
    }
    
    let workoutSetAddButton = UIButton()
    
    override func setup() {
        workoutSetAddButton.setTitle("세트 추가", for: .normal)
        workoutSetAddButton.setTitleColor(UIColor.tintColor, for: .normal)
        workoutSetAddButton.titleLabel?.font = .boldBody
        workoutSetAddButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        workoutSetAddButton.clipsToBounds = true
        workoutSetAddButton.layer.cornerRadius = 10
        
        addSubview(self.workoutSetAddButton)
        
        self.workoutSetAddButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
