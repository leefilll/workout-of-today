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
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.title = "확인"
        rightBarButton.tintColor = .tintColor
        rightBarButton.action = #selector(addWorkout(_:))
        barItem.rightBarButtonItem = rightBarButton
        
        bar.items = [barItem]
        
        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()
    
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
        self.headerView.workoutNameTextField.becomeFirstResponder()
        self.setupModel()
        self.configureTableView()
        self.addTargets()
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
        self.view.backgroundColor = .white
        
        self.headerView = WorkoutAddHeaderView()
        self.headerView.frame.size.height = 120
        self.headerView.workoutNameTextField.delegate = self
        
        self.footerView = WorkoutAddFooterView()
        self.footerView.frame.size.height = Size.Cell.footerHeight
        
        self.tableView = UITableView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = footerView
        self.tableView.rowHeight = Size.Cell.height
        self.tableView.separatorColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .onDrag
        
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.tableView)
        
        self.navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
    }
}

// MARK: objc functions

extension WorkoutAddViewController {
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addWorkout(_ sender: UIBarButtonItem) {
        textFieldDidEndEditing(self.headerView.workoutNameTextField)
        guard let workout = self.workout else { return }
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
        
        //TODO: Cell Model - View Connect
//
//        cell.setCountLabel.text = "\(indexPath.row + 1)"
//        cell.weightTextField.text = workoutSet.weight != 0 ? "\(workoutSet.weight)" : nil
//        cell.repsTextField.text = workoutSet.reps != 0 ? "\(workoutSet.reps)" : nil
        
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
    
}

// MARK: TextField Delegate

extension WorkoutAddViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let objects = DBHandler.shared.realm.objects(Workout.self)
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

// MARK: ModalDidDismissedNotification

extension NSNotification.Name {
    static let WorkoutDidAddedNotification = NSNotification.Name(rawValue: "WorkoutDidAddedNotification")
    static let WorkoutDidModifiedNotification = NSNotification.Name(rawValue: "WorkoutDidModifiedNotification")
}
