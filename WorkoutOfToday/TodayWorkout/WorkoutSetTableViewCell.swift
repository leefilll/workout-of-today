//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

final class WorkoutSetTableViewCell: BaseTableViewCell {
    
    // MARK: Model
    
    var workoutSet: WorkoutSet? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isCompleted: Bool = false {
        didSet {
            if self.isCompleted {
                self.contentView.alpha = 1.0
            } else {
                self.contentView.alpha = 0.7
            }
        }
    }
    
    // MARK: View
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var setCountLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var completeButton: BaseButton!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weightTextField.text = nil
        repsTextField.text = nil
    }

    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        
        setCountLabel.font = .smallBoldTitle
        setCountLabel.textColor = .lightGray
        
        weightTextField.backgroundColor = .concaveColor
        weightTextField.layer.cornerRadius = 10
        weightTextField.delegate = self
        weightTextField.font = .body
        
        repsTextField.backgroundColor = .concaveColor
        repsTextField.layer.cornerRadius = 10
        repsTextField.delegate = self
        repsTextField.font = .body
        
        completeButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitle("취소", for: .selected)
        
        
        self.weightTextField.addToolbar(onDone: (target: self,
                                                 title: "다음",
                                                 action: #selector(nextDidTapped(_:))))
        self.repsTextField.addToolbar(onDone: (target: self,
                                               title: "확인",
                                               action: #selector(doneDidTapped(_:))))

    }
}


// MARK: TextField Delegate

extension WorkoutSetTableViewCell: UITextFieldDelegate {
    @objc func nextDidTapped(_ sender: UIBarButtonItem) {
        self.repsTextField.becomeFirstResponder()
    }
    
    @objc func doneDidTapped(_ sender: UIBarButtonItem) {
        self.repsTextField.resignFirstResponder()
        self.isCompleted = true
    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let text = textField.text else { return }
//
//        switch textField {
//            case weightTextField:
//                if let weight = Int(text), let indexPath = self.indexPath {
//                    delegate?.workoutSetCellDidEndEditingIn(indexPath: indexPath,
//                                                            toWeight: weight)
//                }
//            break
//            case repsTextField:
//                if let reps = Int(text), let indexPath = self.indexPath {
//                    delegate?.workoutSetCellDidEndEditingIn(indexPath: indexPath,
//                                                            toReps: reps)
//                }
//            break
//            default:
//            break
//        }
//    }
//
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet = CharacterSet(charactersIn: "0123456789.").inverted
        if let _ = string.rangeOfCharacter(from: charSet) {
            return false
        }
        return true
    }
}

