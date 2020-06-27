//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SwiftIcons
import RealmSwift

final class WorkoutSetTableViewCell: BasicTableViewCell {
    
    // MARK: Model
    
    var workoutSet: WorkoutSet? {
        didSet {
            fillTextField()
            setNeedsDisplay()
        }
    }
    
    var style: Style? {
        didSet {
            setStyle()
        }
    }
    
    var indexPath: IndexPath?
    
    var delegate: WorkoutSetDidBeginEditing?
    
    // MARK: View
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var divideLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weightTextField.isHidden = true
        repsTextField.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        style = nil
        weightTextField.text = nil
        repsTextField.text = nil
    }
    
    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        
        divideLineView.backgroundColor = .weakTintColor
        divideLineView.layer.cornerRadius = 2
        
        countLabel.font = .smallestBoldTitle
        countLabel.textColor = .lightGray
        
        weightTextField.backgroundColor = .concaveColor
        weightTextField.layer.cornerRadius = 10
        weightTextField.delegate = self
        weightTextField.font = .smallestBoldTitle
        
        repsTextField.backgroundColor = .concaveColor
        repsTextField.layer.cornerRadius = 10
        repsTextField.delegate = self
        repsTextField.font = .smallestBoldTitle
        
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
    
    private func setStyle() {
        guard let style = style else { return }
       switch style {
            case .weightWithReps:
                weightTextField.isHidden = false
                repsTextField.isHidden = false
            case .reps:
                weightTextField.isHidden = true
                repsTextField.isHidden = false
            case .time:
                weightTextField.isHidden = true
                repsTextField.isHidden = false
            default:
                break
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

