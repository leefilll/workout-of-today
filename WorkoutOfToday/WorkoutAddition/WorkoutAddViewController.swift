//
//  AddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import SnapKit

final class WorkoutAddViewController: UIViewController {
    
    // MARK: Model
    
    private var shouldAddWorkout: Bool = false {
        didSet {
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = shouldAddWorkout
            }
        }
    }
    
    var tempWorkout: Workout?
    
    var workoutId: String?
    
    var workoutsOfDayId: String!

    // MARK: View
    
    private var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        
        let handleView = UIView()
        handleView.backgroundColor = .lightGray
        
        bar.addSubview(handleView)
        handleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(5)
            make.width.equalTo(40)
        }
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3
//        let barItem = UINavigationItem()
//        barItem.title = "운동"

//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.title = "취소"
//        leftBarButton.tintColor = .tintColor
//        leftBarButton.action = #selector(dismiss(_:))
//        barItem.leftBarButtonItem = leftBarButton
//        bar.items = [barItem]

        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()

    var workoutAddButton: UIButton!
    
//    var buttonBottomConstraint: ConstraintItem!
    
    var headerView: WorkoutAddHeaderView!
    
    var footerView: WorkoutAddFooterView!
    
    var tableView: UITableView!
    
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupModel()
        self.configureTableView()
        self.addTargets()
        self.addObserverForKeyboard()
        self.headerView.workoutNameTextField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        guard let workout = self.tempWorkout else { return }
        self.headerView.workoutPartButton.partRawValue = workout.part
        self.tableView.reloadData()
    }
}

// MARK: Setup functions

extension WorkoutAddViewController {
    
    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.backgroundColor = .white
        
        self.headerView = WorkoutAddHeaderView()
        self.headerView.frame.size.height = 150
        self.headerView.workoutNameTextField.delegate = self
        
        self.footerView = WorkoutAddFooterView()
        self.footerView.frame.size.height = Size.Cell.footerHeight
        
        self.tableView = UITableView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = footerView
        self.tableView.separatorColor = .clear
//        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .interactive
        
        self.workoutAddButton = UIButton()
        self.workoutAddButton.setBackgroundColor(.tintColor, for: .normal)
        self.workoutAddButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.7),
                                                 for: .highlighted)
        self.workoutAddButton.setBackgroundColor(.lightGray, for: .disabled)
        self.workoutAddButton.setTitle("완료", for: .normal)
        self.workoutAddButton.titleLabel?.textAlignment = .center
        self.workoutAddButton.titleLabel?.font = .smallBoldTitle
        
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.workoutAddButton)

        self.navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.workoutAddButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Size.addButtonHeight)
        }
        
//        self.buttonBottomConstraint = self.workoutAddButton.snp.bottom
        
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.workoutAddButton.snp.top)
        }

    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(WorkoutSetTableViewCell.self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    private func setupModel() {
        if let workoutId = self.workoutId,
            let object = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: workoutId) {
            self.tempWorkout = object.copy() as? Workout
            self.headerView.workoutNameTextField.text = self.tempWorkout?.name
        } else {
            let newWorkout = Workout()
            self.tempWorkout = newWorkout
        }
    }
    
    private func addTargets() {
        self.headerView.workoutPartButton.addTarget(self,
                                                    action: #selector(showActionSheet(_:)),
                                                    for: .touchUpInside)
        
        self.footerView.workoutSetAddButton.addTarget(self,
                                                      action: #selector(workoutSetDidAdded(_:)),
                                                      for: .touchUpInside)
        
        self.workoutAddButton.addTarget(self,
                                        action: #selector(addWorkout(_:)),
                                        for: .touchUpInside)
    }
}

// MARK: objc functions

extension WorkoutAddViewController {
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.headerView.workoutNameTextField.resignFirstResponder()
        //TODO: set resignFirstResponder?
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addWorkout(_ sender: UIBarButtonItem) {
        textFieldDidEndEditing(self.headerView.workoutNameTextField)
        guard let workout = self.tempWorkout else { return }
        if workout.name == "" {
            return
        }
        
        if self.workoutId == nil {
            // create new workout data
            let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self, forPrimaryKey: self.workoutsOfDayId)
            
            DBHandler.shared.write {
                workoutsOfDay?.workouts.append(workout)
            }
            
        } else {
            // update origin data
            guard let originWorkout = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: self.workoutId!) else { return }
            DBHandler.shared.write {
                originWorkout.copy(from: workout)
            }
        }
        self.postNotification(.WorkoutDidAddedNotification)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func workoutSetDidAdded(_ sender: UIButton? = nil) {
        guard let workout = self.tempWorkout else { return }
        let newWorkoutSet = WorkoutSet()
        self.tempWorkout?.sets.append(newWorkoutSet)
        let targetIndexPath = IndexPath(row: workout.numberOfSets - 1, section: 0)
        self.tableView.insertRows(at: [targetIndexPath], with: .automatic)
    }
    
    @objc func showActionSheet(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "파트 설정", message: nil, preferredStyle: .actionSheet)
        for part in Part.allCases {
            let action = makeAction(for: part)
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func makeAction(for part: Part) -> UIAlertAction {
        if part == .none {
            let alertAction = UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil)
            return alertAction
        } else {
            let alertAction = UIAlertAction(title: part.description,
                                            style: .default) { [weak self] _ in
                                                self?.setWorkoutPart(rawValue: part.rawValue)
            }
            return alertAction
        }
    }
    
    private func setWorkoutPart(rawValue part: Part.RawValue) {
        // MARK: 더 좋은 방법이 없을 까...?!
        self.tempWorkout?.part = part
        self.headerView.workoutPartButton.partRawValue = part
    }
}

// MARK: Notification for Keyboard

extension WorkoutAddViewController {
    func addObserverForKeyboard() {
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillShowNotification,
                         object: nil,
                         queue: OperationQueue.main) { noti in
                            guard let userInfo = noti.userInfo else { return }
                            guard let bounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                            
                            let height = bounds.height
                            self.workoutAddButton.snp.remakeConstraints { make in
                                make.bottom.equalToSuperview().offset(-height)
                                make.leading.trailing.equalToSuperview()
                                make.height.equalTo(Size.addButtonHeight)
                            }
                            
                            UIView.animate(withDuration: 0.5) {
                                self.view.layoutIfNeeded()
                            }
        }
        
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillHideNotification,
                         object: nil,
                         queue: OperationQueue.main) { noti in
                            self.workoutAddButton.snp.remakeConstraints { make in
                                make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
                                make.leading.trailing.equalToSuperview()
                                make.height.equalTo(Size.addButtonHeight)
                            }
                            UIView.animate(withDuration: 0.5) {
                                self.view.layoutIfNeeded()
                            }
        }
    }
}


// MARK: TableView DataSource

extension WorkoutAddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempWorkout?.numberOfSets ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workout = self.tempWorkout else { fatalError() }
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workoutSet = workout.sets[indexPath.row]
        
        cell.workoutSet = workoutSet
        cell.setCountLabel.text = "\(indexPath.row + 1)"
        cell.degreeCircleView.clipsToBounds = true
        cell.degreeCircleView.layer.cornerRadius = cell.degreeCircleView.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                self.tempWorkout?.sets.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                tableView.reloadData()
                break
            default:
                break
        }
    }
}

// MARK: TableView Delegate

extension WorkoutAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.Cell.height
    }
    
}

// MARK: TextField Delegate

extension WorkoutAddViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return false }
//        if !string.isEmpty {
//            self.workoutAddButton.isEnabled = true
//        } else if string.isEmpty && text.count <= 1 {
//            self.workoutAddButton.isEnabled = false
//        }
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // have to write in Realm transaction
        DBHandler.shared.write {
            self.tempWorkout?.name = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.tempWorkout?.numberOfSets == 0 {
            workoutSetDidAdded()
        }
        return true
    }
}
