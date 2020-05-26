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
    
    private var moved: CGFloat?
    
    var user: Profile?
    
    var delegate: ProfileDidUpdatedDelegate?
    
    // MARK: View
    
    @IBOutlet weak var titleNavigationBar: UINavigationBar!
    
    @IBOutlet private var subtitleLabels: [UILabel]!
    
    @IBOutlet private var textFields: [FormTextField]!
    
    @IBOutlet private weak var nameTextField: FormTextField!
    
    @IBOutlet private weak var heightTextField: FormTextField!
    
    @IBOutlet private weak var weightTextField: FormTextField!
    
    @IBOutlet weak var optionalPartDescLabel: UILabel!
    
    @IBOutlet weak var fatPercentageTextField: FormTextField!
    
    @IBOutlet weak var muscleWeightTextField: FormTextField!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet var unitLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func setup() {
        tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognize)
        
        titleNavigationBar.topItem?.title = "기본 정보"
        titleNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        titleNavigationBar.shadowImage = UIImage()
        
        subtitleLabels.forEach {
            $0.font = .subheadline
        }
        
        textFields.forEach {
            $0.delegate = self
        }
        
        unitLabels.forEach {
            $0.font = .boldBody
            $0.textColor = .lightGray
        }
        optionalPartDescLabel.font = .description
        optionalPartDescLabel.textColor = .lightGray
        
        editProfileButton.setTitle("확인", for: .normal)
        editProfileButton.setTitleColor(.white, for: .normal)
        editProfileButton.titleLabel?.font = .boldBody
        editProfileButton.backgroundColor = .tintColor
        editProfileButton.clipsToBounds = true
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.addTarget(self, action: #selector(editProfileButtonDidTapped(_:)), for: .touchUpInside)
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        if let user = user {
            self.user = user
            nameTextField.text = user.name
            heightTextField.text = String(user.height)
            weightTextField.text = String(user.getRecentWeight())
            fatPercentageTextField.text = String(user.fatPercentage)
            muscleWeightTextField.text = String(user.muscleWeight)
        }
    }
    
    override func keyboardWillShow(bounds: CGRect?) {
        guard let bounds = bounds else { return }
        let overlappedHeight = view.frame.maxY - bounds.minY
        let extraHeight: CGFloat = 15
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
    func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func editProfileButtonDidTapped(_ sender: UIButton) {
        
        let name = nameTextField.text
        
        guard let heightString = heightTextField.text,
            let weightString = weightTextField.text,
            let height = Double(heightString),
            let weight = Double(weightString)
            else {
                showBasicAlert(title: "필수 입력 사항", message: "키와 몸무게 모두 입력하여 주세요.")
                return
        }
        
        if let user = user {
            DBHandler.shared.write {
                if let name = name {
                    user.name = name
                }
                user.height = height
                user.addNewWeight(weight)
                
                if let fatPercentageString = fatPercentageTextField.text,
                    let muscleWeightString = muscleWeightTextField.text,
                    let fatPercentage = Double(fatPercentageString),
                    let muscleWeight = Double(muscleWeightString) {
                    user.fatPercentage = fatPercentage
                    user.muscleWeight = muscleWeight
                }
            }
        } else {
            let newProfile = Profile()
            newProfile.name = name ?? ""
            newProfile.height = height
            newProfile.addNewWeight(weight)
            if let fatPercentageString = fatPercentageTextField.text,
                let muscleWeightString = muscleWeightTextField.text,
                let fatPercentage = Double(fatPercentageString),
                let muscleWeight = Double(muscleWeightString) {
                newProfile.fatPercentage = fatPercentage
                newProfile.muscleWeight = muscleWeight
            }
            DBHandler.shared.create(object: newProfile)
        }
        delegate?.profileDidUpdated()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Textfield Delegate

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameTextField:
                heightTextField.becomeFirstResponder()
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
