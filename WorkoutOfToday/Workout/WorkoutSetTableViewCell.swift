//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

final class WorkoutSetTableViewCell: UITableViewCell {
    
    // MARK: Model
    
    var workoutSet: WorkoutSet?
    
    var isCompleted: Bool = false {
        didSet {
            // Complete set
        }
    }
    
    // MARK: View
    
    @IBOutlet weak var setCountLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var weightUnitLabel: UILabel!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var repsUnitLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.setup()
    }
    
    private func commonInit() {
        let name = String(describing: type(of: self))
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return }
        guard let view = loadedNib.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func setup() {
        self.weightUnitLabel.font = .lightDescription
        self.weightUnitLabel.text = "kg"
        self.weightUnitLabel.textColor = .lightGray
        
        self.repsUnitLabel.font = .lightDescription
        self.repsUnitLabel.text = "rep"
        self.repsUnitLabel.textColor = .lightGray
        
        self.weightTextField.backgroundColor = .concaveColor
        self.weightTextField.layer.cornerRadius = 10
        self.weightTextField.delegate = self
        self.weightTextField.font = .boldTitle
        
        self.repsTextField.backgroundColor = .concaveColor
        self.repsTextField.layer.cornerRadius = 10
        self.repsTextField.delegate = self
        self.repsTextField.font = .boldTitle
        
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

