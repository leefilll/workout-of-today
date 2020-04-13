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
    
    private let realm = try! Realm()
    
    var workout: Workout? {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    
    var primaryKey: String?
    
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
        self.configureTableView()
        self.addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.workout == nil {
            let newWorkout = Workout()
            realm.addToRealm(object: newWorkout, update: .all)
            self.workout = newWorkout
        }
    }
    
    override func viewWillLayoutSubviews() {
        //        self.workoutNameTextField.text = self.workout?.name
    }
    
    // MARK: Objc functions
    
    
}

// MARK: Setup functions

extension WorkoutAddViewController {
    
    private func setup() {
        self.view.backgroundColor = .white
        
        self.headerView = WorkoutAddHeaderView()
        self.headerView.frame.size.height = 120
        self.headerView.workoutNameTextField.delegate = self
        
        self.footerView = WorkoutAddFooterView()
        footerView.frame.size.height = Size.Cell.footerHeight
        
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
        guard let workout = self.workout else { return }
        let workoutPrimaryKey = workout.id
        self.realm.addToRealm(object: workout, update: .all)
        
        NotificationCenter.default.post(name: NSNotification.Name.ModalDidDisMissedNotification,
                                        object: nil,
                                        userInfo: ["PrimaryKey": workoutPrimaryKey])
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func workoutSetDidAdded(_ sender: UIButton? = nil) {
        guard let workout = self.workout else { return }
        let newWorkoutSet = WorkoutSet()
        
        self.realm.writeToRealm {
            workout.sets.append(newWorkoutSet)
        }
        let targetIndexPath = IndexPath(row: workout.countOfSets - 1, section: 0)
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
                                            style: .cancel) { [weak self] _ in
                                                self?.setWorkoutPart(part: .none)
            }
            return alertAction
        } else {
            let alertAction = UIAlertAction(title: part.description,
                                            style: .default) { [weak self] _ in
                                                self?.setWorkoutPart(part: part)
            }
            return alertAction
        }
        
    }
    
    private func setWorkoutPart(part: Part) {
        self.realm.writeToRealm {
            self.workout?.part = part.rawValue
            self.headerView.workoutPartButton.part = part
        }
    }
}

// MARK: TableView DataSource

extension WorkoutAddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workout?.countOfSets ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workout = self.workout else { fatalError() }
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workoutSet = workout.sets[indexPath.row]
        
        cell.setCountLabel.text = "\(indexPath.row + 1)"
        cell.weightTextField.text = workoutSet.weight != 0 ? "\(workoutSet.weight)" : nil
        cell.repsTextField.text = workoutSet.reps != 0 ? "\(workoutSet.reps)" : nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                self.realm.writeToRealm {
                    self.workout?.sets.remove(at: indexPath.row)
                }
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
        guard let text = textField.text else { return }
        realm.writeToRealm {
            self.workout?.name = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.workout?.countOfSets == 0 {
            workoutSetDidAdded()
        }
        return true
    }
}

// MARK: ModalDidDismissedNotification

extension NSNotification.Name {
    static let ModalDidDisMissedNotification = NSNotification.Name(rawValue: "ModalDidDisMissedNotification")
}
