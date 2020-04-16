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
    
    @IBOutlet weak var setCountLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
    
//    @IBOutlet weak var weightUnitLabel: UILabel!
    
    @IBOutlet weak var repsTextField: UITextField!
    
//    @IBOutlet weak var repsUnitLabel: UILabel!
    
    @IBOutlet weak var degreeCircleView: UIView!
    
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
        self.setCountLabel.font = .smallBoldTitle
        self.setCountLabel.textColor = .lightGray
        
        self.weightTextField.backgroundColor = .concaveColor
        self.weightTextField.keyboardType = .numberPad
        self.weightTextField.layer.cornerRadius = 10
        self.weightTextField.delegate = self
        self.weightTextField.font = .smallBoldTitle
        self.weightTextField.text = "\(self.workoutSet?.weight ?? 0)"
               
        self.repsTextField.backgroundColor = .concaveColor
        self.repsTextField.keyboardType = .numberPad
        self.repsTextField.layer.cornerRadius = 10
        self.repsTextField.delegate = self
        self.repsTextField.font = .smallBoldTitle
        self.repsTextField.text = "\(self.workoutSet?.reps ?? 0)"

        self.degreeCircleView.backgroundColor = .tintColor
        
        
        self.weightTextField.addToolbar(onDone: (target: self,
                                                 title: "다음",
                                                 action: #selector(nextDidTapped(_:))))
        self.repsTextField.addToolbar(onDone: (target: self,
                                               title: "확인",
                                               action: #selector(doneDidTapped(_:))))

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.degreeCircleView.clipsToBounds = true
//        self.degreeCircleView.layer.cornerRadius = self.frame.height / 2
//    }
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

