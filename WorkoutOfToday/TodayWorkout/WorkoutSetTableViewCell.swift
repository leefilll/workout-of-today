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
    
    var style: Style?
    
    var indexPath: IndexPath?
    
    var delegate: WorkoutSetDidBeginEditing?
    
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
    }
    
    private func fillTextField() {
        guard let workoutSet = workoutSet else { return }
        let weight = workoutSet.weight
        let reps = workoutSet.reps
        let weightSting = weight.isInt
            ? String(format: "%d", Int(weight))
            : String(format: ".1f%", weight)
        weightTextField.text = weight != 0 ? weightSting : nil
        repsTextField.text = reps != 0 ? "\(workoutSet.reps)" : nil
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.workoutSetDidBeginEditing(at: indexPath)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            case weightTextField:
                if let weight = Double(textField.text ?? "0") {
                    DBHandler.shared.write {
                        workoutSet?.weight = weight
                    }
                } else {
                    DBHandler.shared.write {
                        workoutSet?.weight = 0
                    }
            }
            case repsTextField:
                if let reps = Int(textField.text ?? "0") {
                    DBHandler.shared.write {
                        workoutSet?.reps = reps
                    }
                } else {
                DBHandler.shared.write {
                    workoutSet?.reps = 0
                }
            }
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

protocol WorkoutSetDidBeginEditing {
    func workoutSetDidBeginEditing(at indexPath: IndexPath?)
}

