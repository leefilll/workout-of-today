//
//  AddTodayWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/10.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

class AddTodayWorkoutTableViewCell: UITableViewCell {
    
    private let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = UIFont.title
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "탭 하여 추가"
        label.font = UIFont.body
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = .re
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        self.selectedBackgroundView = nil
        
        let cardView = CardView()
        
        self.addSubview(cardView)
        cardView.addSubview(self.plusLabel)
        cardView.addSubview(self.descLabel)
        
        cardView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
        }
        
        self.plusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.plusLabel.snp.bottom).offset(20)
        }
    }

}
