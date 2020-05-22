//
//  TodayWorkoutTableHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutTableHeaderView: BasicView, NibLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workoutNoteButton: BasicButton!
    
    @IBOutlet weak var workoutEditButton: UIButton!
    
    override func setup() {
        commonInit()
//        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .smallBoldTitle
        workoutNoteButton.backgroundColor = .weakTintColor
        
        workoutEditButton.setTitle("편집", for: .normal)
        workoutEditButton.setTitleColor(.tintColor, for: .normal)
        workoutEditButton.setTitleColor(.lightGray, for: .selected)
    }
}
