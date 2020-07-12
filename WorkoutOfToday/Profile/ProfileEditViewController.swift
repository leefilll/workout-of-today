//
//  ProfileEditViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class ProfileEditViewController: BasicViewController {
    
    // MARK: Model
    
    private var tapGestureRecognize: UITapGestureRecognizer!
    
    var user: Profile?
    
    var delegate: ProfileDidUpdatedDelegate?
    
    // MARK: View
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet private var subtitleLabels: [UILabel]!
    
    @IBOutlet private var textFields: [FormTextField]!
    
    @IBOutlet private weak var heightTextField: FormTextField!
    
    @IBOutlet private weak var weightTextField: FormTextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var optionalPartDescLabel: UILabel!
    
    @IBOutlet weak var fatPercentageTextField: FormTextField!
    
    @IBOutlet weak var muscleWeightTextField: FormTextField!
    
    @IBOutlet weak var editProfileButton: BasicButton!
    
    @IBOutlet weak var cancelButton: BasicButton!
    
    @IBOutlet var unitLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func setupFeedbackGenerator() {
        notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator?.prepare()
    }
    
    override func setup() {
        tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognize)
        
        titleLabel.text = "프로필 편집"
        titleLabel.font = .smallBoldTitle
        titleLabel.textColor = .defaultTextColor
        
        subtitleLabels.forEach {
            $0.font = .boldBody
            $0.textColor = .defaultTextColor
        }
        
        textFields.forEach {
            $0.delegate = self
        }
        
        unitLabels.forEach {
            $0.font = .body
            $0.textColor = .defaultTextColor
        }
        
        warningLabel.text = "올바른 값을 입력해주세요"
        warningLabel.textColor = Part.chest.color
        warningLabel.font = .subheadline
        warningLabel.isHidden = true
        
        optionalPartDescLabel.font = .boldBody
        optionalPartDescLabel.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        editProfileButton.setTitle("확인", for: .normal)
        editProfileButton.setTitleColor(.white, for: .normal)
        editProfileButton.titleLabel?.font = .smallestBoldTitle
        editProfileButton.backgroundColor = .tintColor
        editProfileButton.addTarget(self, action: #selector(editProfileButtonDidTapped(_:)), for: .touchUpInside)
        
        cancelButton.backgroundColor = .concaveColor
        cancelButton.titleLabel?.font = .smallestBoldTitle
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self,
                               action: #selector(dismiss(_:)),
                               for: .touchUpInside)
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        if let user = user {
            self.user = user
            heightTextField.text = String(user.height)
            weightTextField.text = String(user.getRecentWeight())
            fatPercentageTextField.text = String(user.fatPercentage)
            muscleWeightTextField.text = String(user.muscleWeight)
        }
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

extension ProfileEditViewController {
    @objc
    func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(false)
    }
    
    @objc
    func editProfileButtonDidTapped(_ sender: UIButton) {
        
        var flag = true
        
        // MARK: Check for both of height and weight
        if heightTextField.text == "" {
            heightTextField.backgroundColor = Part.chest.color.withAlphaComponent(0.5)
            flag = false
        } else {
            heightTextField.backgroundColor = .concaveColor
        }
        
        if weightTextField.text == "" {
            weightTextField.backgroundColor = Part.chest.color.withAlphaComponent(0.5)
            flag = false
        } else {
            weightTextField.backgroundColor = .concaveColor
        }
        
        if flag {
            guard let heightString = heightTextField.text,
                let weightString = weightTextField.text,
                let height = Double(heightString),
                let weight = Double(weightString),
                height >= 50, height <= 300, weight > 30, weight <= 250
                else {
                    warningLabel.isHidden = false
                    notificationFeedbackGenerator?.notificationOccurred(.error)
                    return
            }
            if let user = user {
                DBHandler.shared.write {
                    user.height = height
                    user.addNewWeight(weight)
                    
                    if let fatPercentageString = fatPercentageTextField.text,
                        let muscleWeightString = muscleWeightTextField.text,
                        let fatPercentage = Double(fatPercentageString),
                        let muscleWeight = Double(muscleWeightString),
                        fatPercentage >= 0, fatPercentage <= 100, muscleWeight > 5, muscleWeight <= 200 {
                        user.fatPercentage = fatPercentage
                        user.muscleWeight = muscleWeight
                    }
                }
            } else {
                let newProfile = Profile()
                newProfile.height = height
                newProfile.addNewWeight(weight)
                if let fatPercentageString = fatPercentageTextField.text,
                    let muscleWeightString = muscleWeightTextField.text,
                    let fatPercentage = Double(fatPercentageString),
                    let muscleWeight = Double(muscleWeightString),
                    fatPercentage >= 0, fatPercentage <= 100, muscleWeight > 5, muscleWeight <= 200 {
                    newProfile.fatPercentage = fatPercentage
                    newProfile.muscleWeight = muscleWeight
                }
                DBHandler.shared.create(object: newProfile)
            }
            delegate?.profileDidUpdated()
            dismiss(animated: true, completion: nil)
            
        } else {
            notificationFeedbackGenerator?.notificationOccurred(.error)
            return
        }
    }
}

// MARK: Textfield Delegate

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let _ = textField.text, textField.text != "" {
            textField.backgroundColor = .concaveColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case heightTextField:
                weightTextField.becomeFirstResponder()
            case weightTextField:
                fatPercentageTextField.becomeFirstResponder()
            case fatPercentageTextField:
                muscleWeightTextField.becomeFirstResponder()
            case muscleWeightTextField:
                muscleWeightTextField.resignFirstResponder()
            default:
                break
        }
        return true
    }
}
