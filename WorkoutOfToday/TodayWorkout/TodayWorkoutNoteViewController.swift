//
//  TodayWorkoutNoteViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/28.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class TodayWorkoutNoteViewController: BasicViewController {
    
    var workoutsOfDay: WorkoutsOfDay?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteAddButton: BasicButton!
    
    override func setup() {
        let closeButton = CloseButton(target: self, action: #selector(dismiss(_:)))
        navigationBar.topItem?.title = "운동 노트✏️"
        navigationBar.topItem?.rightBarButtonItem = closeButton
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
        
        noteTextView.font = .body
        noteTextView.backgroundColor = .white
        noteTextView.text = workoutsOfDay?.note ?? ""
        noteTextView.placeholder = "노트를 입력해주세요."
        noteTextView.placeholderColor = .lightGray
        
        noteAddButton.backgroundColor = .tintColor
        noteAddButton.titleLabel?.font = .boldBody
        noteAddButton.setTitle("확인", for: .normal)
        noteAddButton.setTitleColor(.white, for: .normal)
        noteAddButton.addTarget(self,
                                action: #selector(notAddButtonDidTapped(_:)),
                                for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func keyboardWillShow(bounds: CGRect?) {
        guard let bounds = bounds else { return }
        let overlappedHeight = view.frame.maxY - bounds.minY
        let extraHeight: CGFloat = 5
        let move = overlappedHeight + extraHeight
        self.moved = move
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= move
        }
    }
    
    override func keyboardWillHide() {
        guard let moved = moved else {
            return }
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += moved
        }
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
