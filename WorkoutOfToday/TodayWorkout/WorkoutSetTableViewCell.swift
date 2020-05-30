//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

final class WorkoutSetTableViewCell: BasicTableViewCell {
    
    // MARK: Model
    
    var workoutSet: WorkoutSet? {
        didSet {
            fillTextField()
            setNeedsDisplay()
        }
    }
    
    // MARK: View
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weightTextField.text = nil
        repsTextField.text = nil
    }

    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        
        countLabel.font = .smallBoldTitle
        countLabel.textColor = .lightGray
        
        weightTextField.backgroundColor = .concaveColor
        weightTextField.layer.cornerRadius = 10
        weightTextField.delegate = self
        weightTextField.font = .boldBody
        
        repsTextField.backgroundColor = .concaveColor
        repsTextField.layer.cornerRadius = 10
        repsTextField.delegate = self
        repsTextField.font = .boldBody
        
        fillTextField()
        
        weightTextField.addToolbar(onDone: (target: self,
                                            title: "다음",
                                            action: #selector(nextDidTapped(_:))))
        repsTextField.addToolbar(onDone: (target: self,
                                          title: "확인",
                                          action: #selector(doneDidTapped(_:))))
    }
    
    private func fillTextField() {
        if let workoutSet = workoutSet {
            let weight = workoutSet.weight
            let reps = workoutSet.reps
            weightTextField.text = weight != 0 ? "\(workoutSet.weight)" : nil
            repsTextField.text = reps != 0 ? "\(workoutSet.reps)" : nil
        }
    }
}

// MARK: objc functions

extension WorkoutSetTableViewCell {
    @objc func nextDidTapped(_ sender: UIBarButtonItem) {
        repsTextField.becomeFirstResponder()
    }

    @objc func doneDidTapped(_ sender: UIBarButtonItem) {
        repsTextField.resignFirstResponder()
        if repsTextField.text == nil {
            return
        }
    }
}

// MARK: TextField Delegate

extension WorkoutSetTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }

        switch textField {
            case weightTextField:
                if let weight = Double(text) {
                    DBHandler.shared.write {
                        workoutSet?.weight = weight
                    }
                }
            break
            case repsTextField:
                if let reps = Int(text) {
                    DBHandler.shared.write {
                        workoutSet?.reps = reps
                    }
                }
            break
            default:
            break
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet = CharacterSet(charactersIn: "0123456789.").inverted
        if let _ = string.rangeOfCharacter(from: charSet) {
            return false
        }
        return true
    }
}

