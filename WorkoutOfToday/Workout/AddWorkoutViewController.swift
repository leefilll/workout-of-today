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
    
    var workout: Workout!
    
    // UI
    private var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        let barItem = UINavigationItem()
        barItem.title = "운동 추가"
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
    
    @objc func addWorkout(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name.ModalDidDisMissedNotification,
                                        object: nil)
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
        
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.tableView)
        
        // constraint
        self.navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
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
        let newWorkoutSet = WorkoutSet()
        self.realm.addToRealm({
            self.workout.sets.append(newWorkoutSet)
        }, object: self.workout,
           update: .modified)
        
        let targetIndexPath = IndexPath(row: self.workout.countOfSets - 1, section: 0)
        self.tableView.insertRows(at: [targetIndexPath], with: .automatic)
    }
    
    func workoutSetCellDidEndEditingIn(indexPath: IndexPath, toWeight weight: Int) {
        let targetWorkoutSet = self.workout.sets[indexPath.row]
        self.realm.addToRealm({
            targetWorkoutSet.weight = weight
        }, object: self.workout,
           update: .modified)
    }
    
    func workoutSetCellDidEndEditingIn(indexPath: IndexPath, toReps reps: Int) {
        let targetWorkoutSet = self.workout.sets[indexPath.row]
        self.realm.addToRealm({
            targetWorkoutSet.reps = reps
        }, object: self.workout,
           update: .modified)
    }
}


// MARK: TableView DataSource
extension AddWorkoutViewController: UITableViewDataSource {
    private func isLastCell(_ indexPath: IndexPath) -> Bool {
        if indexPath.row == self.workout.countOfSets {
            return true
        }
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    private func isButtonSection(section: Int) -> Bool {
        if section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isButtonSection(section: section) {
            return 1
        } else {
            return self.workout.countOfSets
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddWorkoutTableViewCell.self), for: indexPath) as! AddWorkoutTableViewCell
        cell.delegate = self
        
        if isButtonSection(section: indexPath.section) {
            cell.isAddingCell = true
        } else {
            let workoutSet = self.workout.sets[indexPath.row]
            cell.isAddingCell = false
            cell.indexPath = indexPath
            cell.weightTextField.text = workoutSet.weight != 0 ? "\(workoutSet.weight)" : nil
            cell.repsTextField.text = workoutSet.reps != 0 ? "\(workoutSet.reps)" : nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isButtonSection(section: indexPath.section) {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                do {
                    try self.realm.write {
                        self.workout.sets.remove(at: indexPath.row)
                        print("The workoutSet was successfully Deleted")
                    }
                } catch let error as NSError {
                    fatalError("Error occurs while delete workoutSet: \(error)")
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
        guard let text = textField.text else { return }
        self.realm.writeToRealm {
            self.workout.name = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.workout.countOfSets == 0 {
            workoutSetCellDidAdded()
        }
        return true
    }
}

extension NSNotification.Name {
    static let ModalDidDisMissedNotification = NSNotification.Name(rawValue: "ModalDidDisMissedNotification")
}
