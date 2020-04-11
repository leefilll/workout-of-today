//
//  WorkoutsOfTodayTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/11.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

class WorkoutsOfTodayTableViewCell: UITableViewCell {
    
    var workout: Workout? {
        didSet {
            self.workoutNameLabel.text = self.workout?.name
            self.totalVolumeLabel.text = "\(self.workout?.totalVolume ?? 0)"
            self.totalSetLabel.text = "\(self.workout?.countOfSets ?? 0)"
            self.bestSetLabel.text = String(describing: self.workout?.bestSet ?? nil)
        }
    }
    
    private var workoutNameLabel: UILabel!
    
    private var totalVolumeLabel: UILabel!
    
    private var totalSetLabel: UILabel!
    
    private var bestSetLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        let containerView = WorkoutCardView()
        self.workoutNameLabel = UILabel()
        self.workoutNameLabel.font = UIFont.title
        self.workoutNameLabel.textColor = .white
        
        self.totalVolumeLabel = UILabel()
        self.totalVolumeLabel.font = UIFont.title
        self.totalVolumeLabel.textColor = .white
        
        self.totalSetLabel = UILabel()
        self.totalSetLabel.font = UIFont.largeTitle
        self.totalSetLabel.textColor = .white
        
        self.bestSetLabel = UILabel()
        self.bestSetLabel.font = UIFont.description
        self.bestSetLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        let weightUnitLabel = UILabel()
        weightUnitLabel.font = UIFont.subheadline
        weightUnitLabel.textColor = .white
        weightUnitLabel.text = "kg"
        
        let weightStackView = UIStackView(arrangedSubviews: [self.totalVolumeLabel,
                                                             weightUnitLabel])
        weightStackView.axis = .horizontal
        weightStackView.spacing = 5
        
        
        let setUnitLabel = UILabel()
        setUnitLabel.font = UIFont.title
        setUnitLabel.textColor = .white
        setUnitLabel.text = "set"
        
        let setStackView = UIStackView(arrangedSubviews: [self.totalSetLabel,
                                                          setUnitLabel])
        setStackView.axis = .horizontal
        setStackView.alignment = .bottom
        setStackView.spacing = 5
        
        let bestSetUnitLabel = UILabel()
        bestSetUnitLabel.font = UIFont.description
        bestSetUnitLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        let bestSetStackView = UIStackView(arrangedSubviews: [bestSetUnitLabel,
                                                              self.bestSetLabel])
        bestSetStackView.axis = .horizontal
        bestSetStackView.spacing = 3
        
        
        let leftStackView = UIStackView(arrangedSubviews: [self.workoutNameLabel,
                                                           weightStackView])
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.spacing = 5
        
        let rightStackView = UIStackView(arrangedSubviews: [setStackView,
                                                            bestSetStackView])
        rightStackView.axis = .vertical
        rightStackView.alignment = .trailing
        rightStackView.spacing = 5
        
        self.addSubview(containerView)
        containerView.addSubview(leftStackView)
        containerView.addSubview(rightStackView)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.top.bottom.equalToSuperview()
        }
        
        rightStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.top.bottom.equalToSuperview()
        }
    }

}
