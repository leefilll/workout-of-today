//
//  WorkoutSetView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class WorkoutSetView: UIView {
    
    var setCountLabel: UILabel!
    
    var weightLabel: UILabel!
    
    var repsLabel: UILabel!
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.setCountLabel = UILabel()
        self.addSubview(self.setCountLabel)
        
        self.weightLabel = UILabel()
        self.weightLabel.textAlignment = .right
        
        self.repsLabel = UILabel()
        self.repsLabel.textAlignment = .right
        
        self.stackView = UIStackView(arrangedSubviews: [self.weightLabel, self.repsLabel])
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 0
        
        self.addSubview(self.stackView)
        
        self.setCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
        }
        
        self.stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.setCountLabel).offset(30)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
        }
    }
    
}
