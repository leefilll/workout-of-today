//
//  ViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit
import RealmSwift

final class TodayWorkoutViewController: UIViewController {
    
    // properties
    private var workoutsOfToday: WorkoutsOfDay?
   
    private let realm = try! Realm()
    
    
    // UI
    var tableView: UITableView!
    
    private var workoutAddButton : UIButton!
    
    
    // MARK: View Life Cycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchWorkoutOfToday()
        
        workoutAddButton.addTarget(self,
                                   action: #selector(addWorkout(_:)),
                                   for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    @objc func addWorkout(_ sender: UIButton) {
        let vc = AddWorkoutViewController()
        let newWorkout = Workout()
        
        if let workoutsOfToday = workoutsOfToday {
            do {
                try realm.write {
                    workoutsOfToday.workouts.append(newWorkout)
                }
            } catch let error as NSError {
                fatalError("Error occurs while create workout: \(error)")
            }
        } else {
            let workoutsOfToday = WorkoutsOfDay()
            self.workoutsOfToday = workoutsOfToday
            do {
                try realm.write {
                    realm.add(workoutsOfToday)
                    workoutsOfToday.workouts.append(newWorkout)
                }
            } catch let error as NSError {
                fatalError("Error occurs while create workout: \(error)")
            }
        }
        vc.workout = newWorkout
        present(vc, animated: true, completion: nil)
    }
}


extension TodayWorkoutViewController {
    private func setup() {
        view.backgroundColor = .white
        
        let headerView = HeaderView()
        headerView.frame.size.height = 200
        tableView = UITableView()
        tableView.tableHeaderView = headerView
        
        workoutAddButton = UIButton()
        workoutAddButton.backgroundColor = .tintColor
        workoutAddButton.setTitle("운동 추가", for: .normal)

        view.addSubview(tableView)
        view.addSubview(workoutAddButton)
        
        workoutAddButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(workoutAddButton.snp.top)
        }
    }
    
    private func configureTableView() {
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodayWorkoutTableViewCell.self, forCellReuseIdentifier: String(describing: TodayWorkoutTableViewCell.self))
    }
    
    private func fetchWorkoutOfToday() {
        let primaryKey = Date.now.startOfDayWithString
        let workoutsOfToday =
            realm.object(ofType: WorkoutsOfDay.self, forPrimaryKey: primaryKey)
        self.workoutsOfToday = workoutsOfToday
    }
}


// MARK: TableView DataSource
extension TodayWorkoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workoutsOfToday = workoutsOfToday else { return 0 }
        return workoutsOfToday.countOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodayWorkoutTableViewCell.self), for: indexPath) as! TodayWorkoutTableViewCell
        guard let workouts = workoutsOfToday else { fatalError() }
        let workout = workouts.workouts[indexPath.row]
        cell.workout = workout
        return cell
    }
}


// MARK: TableView Delegate
extension TodayWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
