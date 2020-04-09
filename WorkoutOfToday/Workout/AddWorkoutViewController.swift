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
            label.font = UIFont.caption
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
extension AddWorkoutViewController: AddingWorkoutSet {
    func addWorkoutSet() {
        let newWorkoutSet = WorkoutSet()
        do {
            try self.realm.write {
                self.workout.sets.append(newWorkoutSet)
                self.realm.add(self.workout, update: .modified)
                print("Added new workoutSet to \(self.workout.name)")
            }
        } catch let error as NSError {
            fatalError("Error occurs while add workoutSet: \(error)")
        }
        
        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workout.countOfSets + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddWorkoutTableViewCell.self), for: indexPath) as! AddWorkoutTableViewCell
        if isLastCell(indexPath) {
            cell.isAddingCell = true
            cell.delegate = self
        } else {
            cell.isAddingCell = false
            cell.countLabel.text = "\(indexPath.row + 1)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isLastCell(indexPath) {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        do {
            try self.realm.write {
                self.workout.name = text
            }
        } catch let error as NSError {
            fatalError("Error occurs while delete workoutSet: \(error)")
        }
        textField.resignFirstResponder()
        
        if self.workout.countOfSets == 0 {
            addWorkoutSet()
        }
        return true
    }
}
