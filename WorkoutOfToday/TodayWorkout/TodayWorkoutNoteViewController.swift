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
    
    var note: Note?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteAddButton: BasicButton!
    
    @IBOutlet weak var cancelButton: BasicButton!
    
    override func setup() {
        titleLabel.text = "운동 노트"
        titleLabel.font = .smallBoldTitle
        titleLabel.textColor = .defaultTextColor
        
        noteTextView.font = .smallTitle
        noteTextView.backgroundColor = .clear
        noteTextView.text = note?.content ?? ""
        noteTextView.placeholder = "노트를 입력해주세요."
        noteTextView.placeholderColor = .lightGray
        
        noteAddButton.backgroundColor = .tintColor
        noteAddButton.titleLabel?.font = .smallestBoldTitle
        noteAddButton.setTitle("확인", for: .normal)
        noteAddButton.setTitleColor(.white, for: .normal)
        noteAddButton.addTarget(self,
                                action: #selector(notAddButtonDidTapped(_:)),
                                for: .touchUpInside)
        
        cancelButton.backgroundColor = .concaveColor
        cancelButton.titleLabel?.font = .smallestBoldTitle
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self,
                               action: #selector(cancelButtonDidTapped(_:)),
                               for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func keyboardWillShow(in bounds: CGRect?) {
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
    func dismiss(_ sender: UIBarButtonItem?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func notAddButtonDidTapped(_ sender: UIButton) {
        if let note = note {
            DBHandler.shared.write {
                note.content = noteTextView.text
            }
            dismiss(animated: true, completion: nil)
        } else {
            let newNote = Note()
            newNote.content = noteTextView.text
            DBHandler.shared.create(object: newNote)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
//        if let note = note {
//            DBHandler.shared.delete(object: note)
//        }
        dismiss(nil)
    }
}
