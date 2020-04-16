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
    
    var workout: Workout? {
        didSet {
            self.view.setNeedsDisplay()
        }
    }
    
    var workoutId: String?
    
    var workoutsOfDayId: String!

    
    // MARK: View
    
    private var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        let barItem = UINavigationItem()
        barItem.title = "운동"
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "취소"
        leftBarButton.tintColor = .tintColor
        leftBarButton.action = #selector(dismiss(_:))
        barItem.leftBarButtonItem = leftBarButton
//
//        let rightBarButton = UIBarButtonItem()
//        rightBarButton.title = "확인"
//        rightBarButton.tintColor = .tintColor
//        rightBarButton.action = #selector(addWorkout(_:))
//        barItem.rightBarButtonItem = rightBarButton
//
        bar.items = [barItem]
        
        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()
    
    var workoutAddButton: UIButton!
    
    var buttonBottomConstraint: ConstraintItem!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.workoutNameTextField.becomeFirstResponder()
    }
    
    
    // 여기서 workout과 엮인 뷰에 관한 코드를 모두 써줌이따가 할게
    override func viewWillLayoutSubviews() {
        guard let workout = self.workout else { return }
        self.headerView.workoutNameTextField.text = workout.name
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
        self.headerView.frame.size.height = 100
        self.headerView.workoutNameTextField.delegate = self
        
        self.footerView = WorkoutAddFooterView()
        self.footerView.frame.size.height = Size.Cell.footerHeight
        
        self.tableView = UITableView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = footerView
        self.tableView.separatorColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .interactive
        
        self.workoutAddButton = UIButton()
        self.workoutAddButton.setBackgroundColor(.tintColor, for: .normal)
        self.workoutAddButton.setBackgroundColor(.lightGray, for: .disabled)
        self.workoutAddButton.setTitle("확인", for: .normal)
        self.workoutAddButton.titleLabel?.textAlignment = .center
        self.workoutAddButton.isEnabled = false
        
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
            make.height.equalTo(45)
        }
        self.buttonBottomConstraint = self.workoutAddButton.snp.bottom
        
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
    
    private func setupModel() {
        if let workoutId = self.workoutId,
            let object = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: workoutId) {
            self.workout = object.copy() as? Workout
        } else {
            let newWorkout = Workout()
            self.workout = newWorkout
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
        self.view.endEditing(true)
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addWorkout(_ sender: UIBarButtonItem) {
        textFieldDidEndEditing(self.headerView.workoutNameTextField)
        guard let workout = self.workout else { return }
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
        guard let workout = self.workout else { return }
        let newWorkoutSet = WorkoutSet()
        self.workout?.sets.append(newWorkoutSet)
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
        self.workout?.part = part
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
                                make.height.equalTo(65)
                            }
                            
                            UIView.animate(withDuration: 0.7) {
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
                                make.height.equalTo(65)
                            }
                            UIView.animate(withDuration: 0.7) {
                                self.view.layoutIfNeeded()
                            }
        }
    }
}


// MARK: TableView DataSource

extension WorkoutAddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workout?.numberOfSets ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workout = self.workout else { fatalError() }
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workoutSet = workout.sets[indexPath.row]
        
        cell.workoutSet = workoutSet
        cell.setCountLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                self.workout?.sets.remove(at: indexPath.row)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if !string.isEmpty {
            self.workoutAddButton.isEnabled = true
        } else if string.isEmpty && text.count <= 1 {
            self.workoutAddButton.isEnabled = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        DBHandler.shared.write {
            self.workout?.name = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.workout?.numberOfSets == 0 {
            workoutSetDidAdded()
        }
        return true
    }
}
