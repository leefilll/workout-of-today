//
//  AddWorkoutFooterView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class WorkoutAddFooterView: UIView {
    
    var workoutSetAddButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.workoutSetAddButton = UIButton()
        self.workoutSetAddButton.setTitle("세트 추가", for: .normal)
        self.workoutSetAddButton.setTitleColor(UIColor.tintColor, for: .normal)
        self.workoutSetAddButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        self.workoutSetAddButton.clipsToBounds = true
        self.workoutSetAddButton.layer.cornerRadius = 10
        
        self.addSubview(self.workoutSetAddButton)
        
        self.workoutSetAddButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
        }
    }
}
