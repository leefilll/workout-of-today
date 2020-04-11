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

final class AddWorkoutViewController: UIViewController {
    
    // properites
    private let realm = try! Realm()
    
    var workout: Workout?
    
    var isExist: Bool = false
    
    // UI
    let contentView = CardView()
    
    private var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        let barItem = UINavigationItem()
        barItem.title = "운동 추가"
        barItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(dismiss(_:)))
        barItem.rightBarButtonItem = UIBarButtonItem(title: "추가",
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(addWorkout(_:)))
        bar.items = [barItem]
        
        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()
    
    var tableView: UITableView!
    
    var workoutNameTextField: UITextField!
    
    
    // MARK: View Life Cycle
    override func loadView() {
        super.loadView()
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.workout == nil {
            let newWorkout = Workout()
            self.workout = newWorkout
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        NotificationCenter.default.post(name: NSNotification.Name.ModalDidDisMissedNotification,
        //        object: nil)
        self.workout = nil
    }
    
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
}


// MARK: Setup functions
extension AddWorkoutViewController {
    
    private func setup() {
        self.view.backgroundColor = .white
        
        // subViews
        self.workoutNameTextField = UITextField()
        self.workoutNameTextField.placeholder = "운동 이름"
        self.workoutNameTextField.font = UIFont.largeTitle
        self.workoutNameTextField.delegate = self
        
        func descLabel(_ text: String) -> UILabel {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.subheadline
            label.text = text
            return label
        }
        
        let containerView = UIView()
        let countDescLabel = descLabel("Set")
        let weightDescLabel = descLabel("Kg")
        let repsDescLabel = descLabel("reps")
        
        let stackView = UIStackView(arrangedSubviews: [weightDescLabel, repsDescLabel])
        stackView.configureForWorkoutSet()
        containerView.addSubview(countDescLabel)
        containerView.addSubview(stackView)
        
        let headerView = UIView()
        headerView.addSubview(self.workoutNameTextField)
        headerView.addSubview(containerView)
        headerView.frame.size.height = 150
        
        self.tableView = UITableView()
        self.tableView.tableHeaderView = headerView
        self.tableView.rowHeight = Size.Cell.height
        self.tableView.separatorColor = .clear
        self.tableView.allowsSelection = false
        
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.navigationBar)
        self.contentView.addSubview(self.tableView)
        
        //        self.view.addSubview(self.navigationBar)
        //        self.view.addSubview(self.tableView)
        
        // constraint
        self.contentView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            //            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.height.equalTo(Size.Cell.height - 20)
            make.bottom.equalToSuperview()
        }
        
        countDescLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(countDescLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        self.workoutNameTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(containerView.snp.top)
            make.height.equalTo(100)
        }
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(AddWorkoutTableViewCell.self, forCellReuseIdentifier: String(describing: AddWorkoutTableViewCell.self))
    }
}


// MARK: Add WorkoutSet Delegate
extension AddWorkoutViewController: WorkoutSetCellDelegate {
    
    func workoutSetCellDidAdded() {
        guard let workout = self.workout else { return }
        let newWorkoutSet = WorkoutSet()
        if self.isExist {
            self.realm.writeToRealm {
                workout.sets.append(newWorkoutSet)
            }
        } else {
            workout.sets.append(newWorkoutSet)
        }
        
        
        //        self.realm.addToRealm({
        //            workout.sets.append(newWorkoutSet)
        //        }, object: workout,
        //           update: .modified)
        //
        let targetIndexPath = IndexPath(row: workout.countOfSets - 1, section: 0)
        self.tableView.insertRows(at: [targetIndexPath], with: .automatic)
    }
    
    func workoutSetCellDidEndEditingIn(indexPath: IndexPath, toWeight weight: Int) {
        guard let workout = self.workout else { return }
        let targetWorkoutSet = workout.sets[indexPath.row]
        
        if self.isExist {
            self.realm.writeToRealm {
                targetWorkoutSet.weight = weight
            }
        } else {
            targetWorkoutSet.weight = weight
        }
        
            
        //        self.realm.addToRealm({
        //            targetWorkoutSet.weight = weight
        //        }, object: workout,
        //           update: .modified)
    }
    
    func workoutSetCellDidEndEditingIn(indexPath: IndexPath, toReps reps: Int) {
        guard let workout = self.workout else { return }
        let targetWorkoutSet = workout.sets[indexPath.row]
        
        if self.isExist {
            self.realm.writeToRealm {
                targetWorkoutSet.reps = reps
            }
        } else {
            targetWorkoutSet.reps = reps
        }
        
        
        //        self.realm.addToRealm({
        //            targetWorkoutSet.reps = reps
        //        }, object: workout,
        //           update: .modified)
    }
}


// MARK: TableView DataSource
extension AddWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    private func isButtonCell(section: Int) -> Bool {
        if section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isButtonCell(section: section) {
            return 1
        } else {
            guard let workout = self.workout else { return 0}
            return workout.countOfSets
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddWorkoutTableViewCell.self), for: indexPath) as! AddWorkoutTableViewCell
        cell.delegate = self
        
        if isButtonCell(section: indexPath.section) {
            cell.isAddingCell = true
        } else {
            guard let workout = self.workout else { fatalError() }
            let workoutSet = workout.sets[indexPath.row]
            cell.isAddingCell = false
            cell.indexPath = indexPath
            cell.weightTextField.text = workoutSet.weight != 0 ? "\(workoutSet.weight)" : nil
            cell.repsTextField.text = workoutSet.reps != 0 ? "\(workoutSet.reps)" : nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isButtonCell(section: indexPath.section) {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                guard let workout = self.workout else { return }
                //                workout.sets.remove(at: indexPath.row)
                if self.isExist {
                    self.realm.writeToRealm {
                        workout.sets.remove(at: indexPath.row)
                        print("The workoutSet was successfully Deleted")
                    }
                } else {
                    workout.sets.remove(at: indexPath.row)
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
extension AddWorkoutViewController: UITableViewDelegate {
    
}


// MARK: TextField Delegate
extension AddWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
            let workout = self.workout else {
                
                return
        }
//        workout.name = text
        if self.isExist {
            self.realm.writeToRealm {
                workout.name = text
            }
        } else {
            workout.name = text
            
        }
                
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.workout?.countOfSets == 0 {
            workoutSetCellDidAdded()
        }
        return true
    }
}

extension NSNotification.Name {
    static let ModalDidDisMissedNotification = NSNotification.Name(rawValue: "ModalDidDisMissedNotification")
}
