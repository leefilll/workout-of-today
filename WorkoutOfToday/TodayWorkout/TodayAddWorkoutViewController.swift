//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayAddWorkoutViewController: BaseViewController {
    
    // MARK: Model
    
    var workoutsOfDay: WorkoutsOfDay!
    
    // MARK: View
    
    weak var workoutAddButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var partButton: WorkoutPartButton!
    
    @IBOutlet weak var equipmentButton: WorkoutEquipmentButton!
    
    @IBOutlet weak var recentButton: BaseButton!
    
    
    deinit {
        print(#function + " " + String(describing: type(of: self)))
        print(#function + " " + String(describing: type(of: self)))
        print(#function + " " + String(describing: type(of: self)))
        print(#function + " " + String(describing: type(of: self)))
    }
    
    override func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containerViewDidTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        setupWorkoutAddButton()
    }
    
    fileprivate func setupWorkoutAddButton() {
        let workoutAddButton = UIButton()
        workoutAddButton.setBackgroundColor(.tintColor, for: .normal)
        workoutAddButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.7),
                                            for: .highlighted)
        workoutAddButton.setBackgroundColor(.lightGray, for: .disabled)
        workoutAddButton.setTitle("운동 추가", for: .normal)
        workoutAddButton.titleLabel?.textAlignment = .center
        workoutAddButton.titleLabel?.font = .smallBoldTitle
        workoutAddButton.clipsToBounds = true
        workoutAddButton.layer.cornerRadius = 10

        workoutAddButton.addTarget(self,
                                   action: #selector(workoutAddButtonDidTapped(_:)),
                                   for: .touchUpInside)

//        containerView.addSubview(workoutAddButton)
        view.addSubview(workoutAddButton)
        self.workoutAddButton = workoutAddButton
    }
    
    fileprivate func setupTextField() {
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 10
        
        nameTextField.font = .boldTitle
        nameTextField.placeholder = "운동 이름"
        nameTextField.minimumFontSize = UIFont.boldTitle.pointSize
        nameTextField.backgroundColor = .concaveColor
    }
    
    fileprivate func setupButtons() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()
        setupButtons()
        addObserverForKeyboard()
    }
}

extension TodayAddWorkoutViewController {
    @objc
    func containerViewDidTapped(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
    
    @objc
    func workoutAddButtonDidTapped(_ sender: UIButton) {
        guard let text = nameTextField.text else { return }
        if text == "" {
            showBasicAlert(title: "운동 이름을 입력해주세요", message: nil)
            return
        }
        
        let name = text
        let part = partButton.part ?? .none
        let equipment = equipmentButton.equipment ?? .none
        
        let newWorout = Workout()
        newWorout.name = name
        newWorout.part = part
        newWorout.equipment = equipment
        
        DBHandler.shared.write {
            self.workoutsOfDay.workouts.append(newWorout)
        }
        
        dismiss(nil)
    }
    
    @objc
    func dismiss(_ sender: UITapGestureRecognizer?) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: TextField Delegate

extension TodayAddWorkoutViewController: UITextFieldDelegate {
    
}

// MARK: Notification for Keyboard

extension TodayAddWorkoutViewController {
    func addObserverForKeyboard() {
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillShowNotification,
                         object: nil,
                         queue: OperationQueue.main) { [weak self] noti in
                            guard let self = self else { return }
                            guard let userInfo = noti.userInfo else { return }
                            guard let bounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                            
                            let buttonTargetY = bounds.minY - self.workoutAddButton.bounds.height - 10
                            let viewTargetY = bounds.minY - self.view.bounds.height - 20
                            
                            UIView.animate(withDuration: 0.3) {
                                self.view.frame.origin.y = viewTargetY
                                self.workoutAddButton.frame.origin.y = buttonTargetY
                            }
        }
        
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillHideNotification,
                         object: nil,
                         queue: OperationQueue.main) { [weak self] noti in
                            guard let self = self else { return }
                            
                            var targetFrame = self.workoutAddButton.frame
                            targetFrame.origin.y = self.view.frame.maxY + 10
                            
                            UIView.animate(withDuration: 0.3) {
                                self.view.center = self.view.center
                                self.workoutAddButton.frame = targetFrame
                            }
        }
    }
}
