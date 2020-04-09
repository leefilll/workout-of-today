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
    
    private var didSetConstraint: Bool = false
    
    var workout: Workout? {
        didSet {
            if let workout = workout {
                self.titleLabel.text = workout.name
                self.descriptionLabel.text =
                "SET: \(workout.countOfSets) VOL: \(workout.totalVolume)"
            }
        }
    }
    
    
    // UI
    private var cardView: CardView!
    
    var titleLabel: UILabel!
    
    var descriptionLabel: UILabel!
    
    var workoutSetViews: [WorkoutSetView] = []
    
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
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.description
        descriptionLabel.textColor = UIColor.lightGray
        self.cardView.addSubview(descriptionLabel)
        
        self.cardView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(padding)
            make.bottom.trailing.equalToSuperview().offset(-padding)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
        }
    }
    
    override func updateConstraints() {
        if !self.didSetConstraint {
            setupWorkoutSetViews()
            self.didSetConstraint = true
        }
        
        super.updateConstraints()
    }
    
    private func setupWorkoutSetViews() {
        guard let workout = self.workout else { return }
        for index in 0..<workout.countOfSets {
            let workoutSet = workout.sets[index]
            let workoutSetView = WorkoutSetView()
            workoutSetView.setCountLabel.text = "\(index + 1) set"
            workoutSetView.weightLabel.text = "\(workoutSet.weight) kg"
            workoutSetView.repsLabel.text = "\(workoutSet.reps) reps"
            workoutSetView.frame.size.height = Size.CellView.height
            self.workoutSetViews.append(workoutSetView)
        }
        
        let stackView = UIStackView(arrangedSubviews: self.workoutSetViews)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        self.cardView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(Inset.Cell.veticalInset)
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.height.equalTo(self.workoutSetViews.count * Int(Size.CellView.height))
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
        }
    }
}


// MARK: StackView class for dynamic stackView
extension TodayWorkoutTableViewCell {
    
}
