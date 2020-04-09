//
//  TodayWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class TodayWorkoutTableViewCell: UITableViewCell {
    
    // properties
    private let padding = 10
    
    var workout: Workout? {
        didSet {
            titleLabel.text = workout?.name
        }
    }
    
    
    // UI
    private var cardView: CardView!
    
    var titleLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        cardView = CardView()
        addSubview(cardView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.title
        cardView.addSubview(titleLabel)
        
        cardView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(padding)
            make.bottom.trailing.equalToSuperview().offset(-padding)
            make.height.greaterThanOrEqualTo(300)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
    }
}
