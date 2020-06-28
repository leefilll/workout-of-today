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
    
    override func setup() {
        tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognize)
        
//        navigationBar.topItem?.title = "기본 정보"
//        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationBar.shadowImage = UIImage()
        
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
        view.endEditing(true)
    }
    
    @objc
    func editProfileButtonDidTapped(_ sender: UIButton) {
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
