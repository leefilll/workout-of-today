//
//  TodayWorkoutTableHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutTableHeaderView: BaseView, NibLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workoutNoteButton: BaseButton!
    
    override func setup() {
        commonInit()
//        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .smallBoldTitle
        workoutNoteButton.backgroundColor = .weakTintColor
    }
}
