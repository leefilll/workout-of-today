//
//  ViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class TodayWorkoutViewController: UIViewController {
    
    // MARK: Model
    
    var workoutsOfDay: WorkoutsOfDay!
    
    var workoutsOfDayId: String!
    
    // MARK: View
    
    var tableView: UITableView!
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.fetchWorkoutOfToday()
        self.addObserverToNotificationCenter(.WorkoutDidAddedNotification,
                                             selector: #selector(reloadTableView(_:)))
        
        
        var c = 0
        print("REALM")
        let WOD = DBHandler.shared.realm.objects(WorkoutsOfDay.self)
        print("WOD---------")
        for wod in WOD {
            print("\(wod.id)")
            for workout in wod.workouts {
                print("\(workout.name) - \(workout.numberOfSets)")
                for (idx,set) in workout.sets.enumerated() {
                    c += 1
                    print("\(idx+1): \(set.weight) - \(set.reps)")
                }
            }
        }
        print("TOTAL COUNT: \(c)")
        
        
        let wholeSets = DBHandler.shared.realm.objects(WorkoutSet.self)
        wholeSets.forEach{ set in
            print("\(set.weight) - \(set.reps)")
        }
        print("TOTAL COUNT: \(wholeSets.count)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Setup

extension TodayWorkoutViewController {
    private func setup() {
        self.view.backgroundColor = .white
        
        self.title = "오늘의 운동"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.barTintColor = .groupTableViewBackground
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            navigationBar.topItem?.prompt = "2020년"
        }
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
        }
    }
    
    private func configureTableView() {
        self.tableView.separatorColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delaysContentTouches = false
        self.tableView.register(WorkoutTableViewCell.self)
    }
    
    private func fetchWorkoutOfToday() {
//        if self.workoutsOfDay != nil {
////            let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self,
////                                                             forPrimaryKey: self.workoutsOfDayId)
////            DBHandler.shared.write {
////                self.workoutsOfDay = workoutsOfDay
////            }
//        } else {
//            // there is no WOD already existed
//            let newWorkoutsOfDay = WorkoutsOfDay()
//            DBHandler.shared.create(object: newWorkoutsOfDay)
//            self.workoutsOfDay = newWorkoutsOfDay
//        }
    }
}

// MARK: Delegate pattern

extension TodayWorkoutViewController {
    
    @objc func reloadTableView(_ notification: Notification) {
        self.fetchWorkoutOfToday()
        self.tableView.reloadData()
    }
}

// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutsOfDay.numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutTableViewCell.self, for: indexPath)
        guard let workoutsOfToday = self.workoutsOfDay else { fatalError() }
        let workout = self.workoutsOfDay.workouts[indexPath.row]
        cell.workout = workout
        return cell
    }
}

// MARK: TableView Delegate

extension TodayWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WorkoutTableViewCell
            else { return }
        let currentColor = cell.containerView.backgroundColor
        cell.containerView.backgroundColor = currentColor?.withAlphaComponent(0.6)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WorkoutTableViewCell
            else { return }
        cell.containerView.backgroundColor = UIColor.partColor(cell.workout?.part ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workoutsOfToday = self.workoutsOfDay else { return }
        let vc = WorkoutAddViewController()
        let workout = workoutsOfToday.workouts[indexPath.row]
        vc.workoutId = workout.id
        self.present(vc, animated: true, completion: nil)
    }
}
// TODO:- If there is workout here, the add vc make the fields filled
