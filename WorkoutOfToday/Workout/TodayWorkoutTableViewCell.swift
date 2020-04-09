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
            self.titleLabel.text = workout?.name
        }
    }
    
    
    // UI
    private var cardView: CardView!
    
    var titleLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.cardView = CardView()
        self.addSubview(self.cardView)
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.title
        self.cardView.addSubview(self.titleLabel)
        
        self.cardView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(padding)
            make.bottom.trailing.equalToSuperview().offset(-padding)
            make.height.greaterThanOrEqualTo(300)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
    }
}
