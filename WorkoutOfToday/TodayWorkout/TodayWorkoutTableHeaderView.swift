//
//  TodayWorkoutTableHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import SwiftIcons

class TodayWorkoutTableHeaderView: BasicView, NibLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workoutNoteButton: BasicButton!
    
    override func setup() {
        commonInit()
        titleLabel.font = .smallBoldTitle
        titleLabel.textColor = .defaultTextColor
        workoutNoteButton.backgroundColor = .weakTintColor
        workoutNoteButton.setTitleColor(.tintColor, for: .normal)
        workoutNoteButton.setTitle("노트", for: .normal)
    }
}
