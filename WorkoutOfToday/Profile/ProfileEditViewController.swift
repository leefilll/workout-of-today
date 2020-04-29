//
//  ProfileEditViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class ProfileEditViewController: BaseViewController {
    
    fileprivate var tapGestureRecognize: UITapGestureRecognizer!
    
    fileprivate var moved: CGFloat?

    @IBOutlet weak var titleNavigationBar: UINavigationBar!
    
    @IBOutlet fileprivate var subtitleLabels: [UILabel]!
    
    @IBOutlet fileprivate var textFields: [FormTextField]!
    
    @IBOutlet fileprivate weak var nameTextField: FormTextField!
    
    @IBOutlet fileprivate weak var heightTextField: FormTextField!
    
    @IBOutlet fileprivate weak var weightTextField: FormTextField!
    
    @IBOutlet weak var bmiLabel: UILabel!
    
    @IBOutlet weak var bmiResultLabel: UILabel!
    
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
        
        let labelTexts = ["이름", "키", "몸무게"]
        
        for (i, label) in subtitleLabels.enumerated() {
            label.text = labelTexts[i]
            label.font = .boldBody
        }
        
        textFields.forEach {
            $0.font = .boldBody
            $0.backgroundColor = .concaveColor
            $0.delegate = self
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        unitLabels.forEach {
            $0.font = .boldBody
            $0.textColor = .lightGray
        }
        
        editProfileButton.setTitle("확인", for: .normal)
        editProfileButton.setTitleColor(.white, for: .normal)
        editProfileButton.titleLabel?.font = .boldBody
        editProfileButton.backgroundColor = .tintColor
        editProfileButton.clipsToBounds = true
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.addTarget(self, action: #selector(editProfileButtonDidTapped(_:)), for: .touchUpInside)
        
        bmiLabel.font = .subheadline
        bmiLabel.textColor = .lightGray
        bmiLabel.text = "키와 몸무게를 입력하세요"
        
        bmiResultLabel.font = .subheadline
        bmiResultLabel.textColor = .lightGray
        bmiResultLabel.text = ""
    }
    
    override func keyboardWillShow(bounds: CGRect? = nil) {
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
            print(#function)
            print(#function)
            print(#function)
            print(#function)
            return }
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += moved
        }
    }
    
    fileprivate func updateBMILabels(_ bmi: Double) {
        let bmiString = String(format: "%.2f", bmi)
        bmiLabel.text = "BMI지수 \(bmiString)"
        bmiResultLabel.text = checkBMI(bmi)
    }
    
    fileprivate enum BMI {
        case lowweight
        case regular
        case overweight
        case obesity
        case extremelyObesity
        
        static func checkBmi(_ bmi: Double) -> BMI {
            if bmi <= 18.5 {
                // 저체중
                return .lowweight
            } else if bmi <= 23 {
                // 정싱
                return .regular
            } else if bmi <= 25 {
                // 과체중
                return .overweight
            } else if bmi <= 30 {
                // 비만
                return .obesity
            } else {
                // 고도 비만
                return .extremelyObesity
            }
        }
        
        var string: String {
            switch self {
                case .lowweight: return "저체중"
                case .regular: return "정상"
                case .overweight: return "과체중"
                case .obesity: return "비만"
                case .extremelyObesity: return "고도 비만"
            }
        }
    }
    
    fileprivate func checkBMI(_ bmi: Double) -> String {
        let bmi = BMI.checkBmi(bmi)
        return bmi.string
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
//        let newProfile = Profile()
//        
//        if let name = nameTextField.text {
//            newProfile.name = name
//        }
//        
//        if let heightString = heightTextField.text,
//            let height = Double(heightString) {
//            newProfile.height = height
//        }
//        
//        if let weightString = weightTextField.text,
//            let weight = Double(weightString) {
//            newProfile.addNewWeight(weight)
//        }
    }
}

// MARK: Textfield Delegate

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let heightText = heightTextField.text,
            let weightText = weightTextField.text,
        var height = Double(heightText),
        let weight = Double(weightText) else { return }
        height = height / 100
        let bmi = weight / (height * height)
        
        updateBMILabels(bmi)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameTextField:
                heightTextField.becomeFirstResponder()
            case heightTextField:
                weightTextField.becomeFirstResponder()
            case weightTextField:
                weightTextField.resignFirstResponder()
            default:
                break
        }
        return true
    }
}
