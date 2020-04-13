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
    
    // MARK: Model
    
    private var workoutsOfToday: WorkoutsOfDay?
    
    private let realm = try! Realm()
    
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
        self.addObserverToNotificationCenter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        let primaryKey = Date.now.startOfDayWithString
        let workoutsOfToday =
            realm.object(ofType: WorkoutsOfDay.self, forPrimaryKey: primaryKey)
        
        if let workoutsOfToday = workoutsOfToday {
            self.workoutsOfToday = workoutsOfToday
        } else {
            // If there is no workouts of today.
            let workoutsOfToday = WorkoutsOfDay()
            self.workoutsOfToday = workoutsOfToday
            self.realm.addToRealm(object: workoutsOfToday, update: .all)
        }
    }
}


// MARK: Delegate pattern

extension TodayWorkoutViewController {
    
    private func addObserverToNotificationCenter() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(addWorkoutViewControllerDidDismissed(_:)),
                         name: NSNotification.Name.ModalDidDisMissedNotification,
                         object: nil)
    }
    
    @objc func addWorkoutViewControllerDidDismissed(_ notification: Notification) {
        guard let workoutsOfToday = self.workoutsOfToday else { return }
        if let workoutPrimaryKey = notification.userInfo?["PrimaryKey"] as? String,
            let addedWorkout = self.realm.object(ofType: Workout.self,
                                                 forPrimaryKey: workoutPrimaryKey){
            if !workoutsOfToday.workouts.contains(addedWorkout) {
                self.realm.writeToRealm {
                    workoutsOfToday.workouts.append(addedWorkout)
                }
            }

            self.tableView.reloadData()
            let countOfWorkouts = workoutsOfToday.countOfWorkouts
            let targetIndexPath = IndexPath(row: countOfWorkouts - 1, section: 0)
            self.tableView.scrollToRow(at: targetIndexPath, at: .middle, animated: true)
        }
    }
}


// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workoutsOfToday = self.workoutsOfToday else { return 0 }
        let countOfWorkouts = workoutsOfToday.countOfWorkouts
        return countOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutTableViewCell.self,
                                                 for: indexPath)
        guard let workoutsOfToday = self.workoutsOfToday else { fatalError() }
        let workout = workoutsOfToday.workouts[indexPath.row]
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
//        cell.containerView.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WorkoutTableViewCell
            else { return }
        cell.containerView.backgroundColor = UIColor.partColor(cell.workout?.part ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workoutsOfToday = self.workoutsOfToday else { return }
        let vc = WorkoutAddViewController()
        let workout = workoutsOfToday.workouts[indexPath.row]
        vc.workout = workout
        self.present(vc, animated: true, completion: nil)
    }
}
// TODO:- If there is workout here, the add vc make the fields filled

