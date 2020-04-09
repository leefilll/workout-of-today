//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit
import RealmSwift

final class AddWorkoutTableViewCell: UITableViewCell {
    
    // properties
    var delegate: WorkoutSetCellDelegate?
    
    var indexPath: IndexPath? {
        didSet {
            if let indexPath = indexPath {
                self.countLabel.text = "\(indexPath.row + 1)"
            }
        }
    }
    
    var isAddingCell: Bool = false {
        willSet {
            self.addWorkoutSetButton.isHidden = !newValue
            self.containerView.isHidden = newValue
        }
    }
    
    var isCompleted: Bool = false {
        didSet {
            // Complete set
        }
    }
    
    // UI
    private var containerView: UIView!
    
    var addWorkoutSetButton: UIButton!
    
    var countLabel: UILabel!
    
    var weightTextField: UITextField!
    
    var repsTextField: UITextField!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    deinit {
        self.delegate = nil
    }
    
    private func setup() {
        self.addWorkoutSetButton = UIButton()
        self.addWorkoutSetButton.setTitle("세트 추가", for: .normal)
        self.addWorkoutSetButton.setTitleColor(UIColor.tintColor, for: .normal)
        self.addWorkoutSetButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        self.addWorkoutSetButton.isHidden = true
        self.addWorkoutSetButton.layer.cornerRadius = 10
        self.addWorkoutSetButton.layer.masksToBounds = true
        self.addWorkoutSetButton.addTarget(self, action: #selector(addWorkoutSet(_:)), for: .touchUpInside)
        
        self.containerView = UIView()
        
        self.countLabel = UILabel()
        self.countLabel.textAlignment = .center
        
        func textField(with placeholder: String) -> UITextField {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.backgroundColor = UIColor.concaveColor.withAlphaComponent(0.6)
            textField.font = UIFont.body
            textField.textAlignment = .center
            textField.layer.cornerRadius = 10
            textField.keyboardType = .decimalPad
            textField.delegate = self
            return textField
        }
        
        self.weightTextField = textField(with: "kg")
        self.repsTextField = textField(with: "0")
        self.weightTextField.addToolbar(onDone: (target: self,
                                                 title: "다음",
                                                 action: #selector(nextDidTapped(_:))))
        self.repsTextField.addToolbar(onDone: (target: self,
                                               title: "확인",
                                               action: #selector(doneDidTapped(_:))))
        
        let stackView = UIStackView(arrangedSubviews: [self.weightTextField,
                                                       self.repsTextField])
        stackView.configureForWorkoutSet()
        
        self.addSubview(self.addWorkoutSetButton)
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.countLabel)
        self.containerView.addSubview(stackView)
        
        self.addWorkoutSetButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
        }
        
        self.containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
        }
        
        self.countLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.countLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc func addWorkoutSet(_ sender: UIButton) {
        self.delegate?.workoutSetCellDidAdded()
    }
}


// MARK: TextField Delegate
extension AddWorkoutTableViewCell: UITextFieldDelegate {
    @objc func nextDidTapped(_ sender: UIBarButtonItem) {
        self.repsTextField.becomeFirstResponder()
    }
    
    @objc func doneDidTapped(_ sender: UIBarButtonItem) {
        self.repsTextField.resignFirstResponder()
        self.isCompleted = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
            case weightTextField:
                if let weight = Int(text), let indexPath = self.indexPath {
                    delegate?.workoutSetCellDidEndEditingIn(indexPath: indexPath,
                                                            toWeight: weight)
                }
            break
            case repsTextField:
                if let reps = Int(text), let indexPath = self.indexPath {
                    delegate?.workoutSetCellDidEndEditingIn(indexPath: indexPath,
                                                            toReps: reps)
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


protocol WorkoutSetCellDelegate {
    
    func workoutSetCellDidAdded()
    
    func workoutSetCellDidEndEditingIn(indexPath: IndexPath, toWeight weight: Int)
    
    func workoutSetCellDidEndEditingIn(indexPath: IndexPath, toReps reps: Int)
}
