//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayAddWorkoutViewController: BaseViewController {
    
    weak var workoutAddButton: UIButton!
    
    weak var containerView: UIView!
    
    override func setup() {
        view.backgroundColor = .clear
        setupContainerView()
        setupWorkoutAddButton()
    }
    
    fileprivate func setupContainerView() {
        view.backgroundColor = .clear
        
        let containerView = TodayWorkoutAddView()
        containerView.backgroundColor = .red
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        containerView.closeButton.addTarget(self,
                                            action: #selector(dismiss(_:)),
                                            for: .touchUpInside)
        
        view.addSubview(containerView)
        self.containerView = containerView
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
        
        containerView.addSubview(workoutAddButton)
        self.workoutAddButton = workoutAddButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverForKeyboard()
    }
}

extension TodayAddWorkoutViewController {
    @objc
    func workoutAddButtonDidTapped(_ sender: UIButton) {
        print(#function)
    }
    
    @objc
    func dismiss(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
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
                            
                            let height = bounds.height
                            let currentMaxY = self.workoutAddButton.frame.maxY
                            let heightForButton = self.view.bounds.height - currentMaxY
                            let extraHeight: CGFloat = 5
                            let heightToMove = height - heightForButton + extraHeight
                            
                            print("heightToMove: \(heightToMove)")
                            print("KEYOBOARD")
                            UIView.animate(withDuration: 0.5) {
                                self.workoutAddButton.frame.origin.y -= heightToMove
                                
                            }
        }
        
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillHideNotification,
                         object: nil,
                         queue: OperationQueue.main) { [weak self] noti in
                            guard let self = self else { return }
                            self.workoutAddButton.snp.remakeConstraints { make in
                                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                                make.leading.trailing.equalToSuperview()
                                make.height.equalTo(Size.addButtonHeight)
                            }
                            UIView.animate(withDuration: 0.5) {
                                self.view.layoutIfNeeded()
                            }
        }
    }
}
