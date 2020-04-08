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

class AddWorkoutViewController: UIViewController {
    
    private var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        let barItem = UINavigationItem()
        barItem.title = "운동 추가"
//        barItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismiss(_:)))
        barItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(addWorkout(_:)))
        //        barItem.rightBarButtonItem?.isEnabled = false
        bar.items = [barItem]
        
        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()
    
    private let realm = try! Realm()
    
    var workout: Workout!
    
    var tableView: UITableView!
    
    var workoutNameTextField: UITextField!
    
    
    // MARK: View Life Cycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
//    @objc func dismiss(_ sender: UIBarButtonItem) {
//        self.dismiss(animated: true, completion: nil)
//
//    }
//
    @objc func addWorkout(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK:- Setup functions
extension AddWorkoutViewController {
    
    private func setup() {
        view.backgroundColor = .white
        
        workoutNameTextField = UITextField()
        workoutNameTextField.placeholder = "운동 이름"
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let fontSize = font.pointSize
        workoutNameTextField.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        workoutNameTextField.delegate = self
        
        let headerView = UIView()
        headerView.addSubview(workoutNameTextField)
        headerView.frame.size.height = 150
        
        tableView = UITableView()
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 60
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
        
        workoutNameTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddWorkoutTableViewCell.self, forCellReuseIdentifier: String(describing: AddWorkoutTableViewCell.self))
    }
}



// MARK:- Add WorkoutSet Delegate
extension AddWorkoutViewController: AddingWorkoutSet {
    func addWorkoutSet() {
        let newWorkoutSet = WorkoutSet()
        do {
            try realm.write {
                workout.sets.append(newWorkoutSet)
                realm.add(workout, update: .modified)
                print("Added new workoutSet to \(workout.name)")
            }
        } catch let error as NSError {
            fatalError("Error occurs while add workoutSet: \(error)")
        }
        
        tableView.reloadData()
    }
}


// MARK:- TableView Delegate
extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    private func isLastCell(_ indexPath: IndexPath) -> Bool {
        if indexPath.row == workout.countOfSets {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.countOfSets + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddWorkoutTableViewCell.self), for: indexPath) as! AddWorkoutTableViewCell
        if isLastCell(indexPath) {
            cell.isAddingCell = true
            cell.delegate = self
//            cell.setAddButton.addTarget(self, action: #selector(addWorkoutSet(_:)), for: .touchUpInside)
        } else {
            cell.isAddingCell = false
            //            let workoutSet = workout.sets[indexPath.row]
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
                try realm.write {
                    workout.sets.remove(at: indexPath.row)
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


// MARK:- TextField Delegate
extension AddWorkoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        do {
            try realm.write {
                workout.name = text
            }
        } catch let error as NSError {
            fatalError("Error occurs while delete workoutSet: \(error)")
        }
        textField.resignFirstResponder()
        
        if workout.countOfSets == 0 {
            addWorkoutSet()
        }
        return true
    }
}
