//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class TodayAddWorkoutViewController: BaseViewController {
    
    // MARK: Model
    
    var tempWorkout: Workout! {         // temporary workout for settings
        didSet {
            equipmentButton.equipment = tempWorkout.equipment
            nameTextField.text = tempWorkout.name
            partButton.part = tempWorkout.part
            view.layoutIfNeeded()
        }
    }
    
    var workoutsOfDay: WorkoutsOfDay!   // passed by TodayVC
    
    var recentWorkouts: [Workout]?      // recent Objects for collectionView
    
    // MARK: View
    
    weak var workoutAddButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var partButton: WorkoutPartButton!
    
    @IBOutlet weak var equipmentButton: WorkoutEquipmentButton!
    
    @IBOutlet weak var recentDescLabel: UILabel!
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    deinit {
        print(#function + " " + String(describing: type(of: self)))
        print(#function + " " + String(describing: type(of: self)))
        print(#function + " " + String(describing: type(of: self)))
        print(#function + " " + String(describing: type(of: self)))
    }
    
    override func setup() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(containerViewDidTapped(_:)))
//        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        tempWorkout = Workout()
        
        setupWorkoutAddButton()
        setupTextField()
        setupButtons()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addObserverForKeyboard()
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
        // Connect with tempWorkout
    }
    
    fileprivate func setupCollectionView() {
        recentWorkouts = DBHandler.shared.fetchRecentObjects(ofType: Workout.self)
        
        recentDescLabel.font = .description
        recentDescLabel.textColor = .lightGray
        recentDescLabel.text = "최근 운동"
        
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        recentCollectionView.register(RecentWorkoutCollectionViewCell.self)
        recentCollectionView.delaysContentTouches = false
        
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
        DBHandler.shared.write {
            self.workoutsOfDay.workouts.append(tempWorkout)
        }
        
        dismiss(nil)
    }
    
    @objc
    func dismiss(_ sender: UITapGestureRecognizer?) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate

extension TodayAddWorkoutViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        print(#function)
        print(#function)
        print(#function)
        guard let selectedWorkout = recentWorkouts?[indexPath.item] else {
            print("Return")
            print("Return")
            print("Return")
            print("Return")
            print("Return")
            return
            
        }
        tempWorkout = selectedWorkout.copy() as? Workout
        print(tempWorkout.name)
        print(tempWorkout.name)
        print(tempWorkout.name)
        print(tempWorkout.name)
    }
}

// MARK: CollectionView DataSourec

extension TodayAddWorkoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentWorkouts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecentWorkoutCollectionViewCell.self,
                                                      for: indexPath)
        let workout = recentWorkouts?[indexPath.row]
        cell.workout = workout
        
        return cell
    }
}

// MARK: CollectionView Delegate Flow Layout

extension TodayAddWorkoutViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let workout = recentWorkouts?[indexPath.item] else { return .zero }

        let workoutName = workout.name
        let itemSize = workoutName.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldBody
        ])

        let extraWidth: CGFloat = 30

        return CGSize(width: itemSize.width + extraWidth,
                      height: Size.recentCollectionViewHeight)
    }
}


// MARK: TextField Delegate

extension TodayAddWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        tempWorkout?.name = text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
