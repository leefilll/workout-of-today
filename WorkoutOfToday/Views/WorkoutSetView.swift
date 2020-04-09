//
//  SetView.swift
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
        setCountLabel = UILabel()
        addSubview(setCountLabel)
        
        weightLabel = UILabel()
        weightLabel.backgroundColor = .red
        repsLabel = UILabel()
        repsLabel.backgroundColor = .blue
        stackView = UIStackView(arrangedSubviews: [weightLabel, repsLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        addSubview(stackView)
        
        setCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(setCountLabel).offset(20)
            make.trailing.equalToSuperview().offset(20)
        }
    }
    
}
