//
//  TodayWorkoutNoteViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/28.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutNoteViewController: BasicViewController {
    
    var workoutsOfDay: WorkoutsOfDay?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var closeButton: CloseButton!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteAddButton: BasicButton!
    
    override func setup() {
        titleLabel.font = .boldTitle
        titleLabel.text = "운동 노트"
        
        noteTextView.font = .subheadline
        noteTextView.backgroundColor = .white
        noteTextView.text = workoutsOfDay?.note ?? ""
        
        noteAddButton.backgroundColor = .tintColor
        noteAddButton.titleLabel?.font = .boldBody
        noteAddButton.setTitle("저장", for: .normal)
        noteAddButton.setTitleColor(.white, for: .normal)
        noteAddButton.addTarget(self,
                                action: #selector(notAddButtonDidTapped(_:)),
                                for: .touchUpInside)
        closeButton.addTarget(self,
                              action: #selector(dismiss(_:)),
                              for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

// MARK: objc functions

extension TodayWorkoutNoteViewController {
    @objc
    func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func notAddButtonDidTapped(_ sender: UIButton) {
        guard let note = noteTextView.text else { return }
        
        if let workoutsOfDay = workoutsOfDay {
            // if WOD already exists
            DBHandler.shared.write {
                workoutsOfDay.note = note
            }
        } else {
            let newWorkoutsOfDay = WorkoutsOfDay()
            DBHandler.shared.create(object: newWorkoutsOfDay)
            DBHandler.shared.write {
                newWorkoutsOfDay.note = note
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
