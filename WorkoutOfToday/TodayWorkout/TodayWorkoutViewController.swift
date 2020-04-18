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
    
    var workoutsOfDay: WorkoutsOfDay!
    
    var token: NotificationToken?
    
    // MARK: View
    
    weak var tableView: UITableView!
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addNotificationBlock()
        
        // MARK: Checking memory alloc
        var c = 0
        var d = 0
        let WOD = DBHandler.shared.realm.objects(WorkoutsOfDay.self)
        for wod in WOD {
            for workout in wod.workouts {
                d += 1
                for _ in workout.sets {
                    c += 1
                }
            }
        }
        print("TOTAL SET COUNT: \(c)")
        let wholeSets = DBHandler.shared.realm.objects(WorkoutSet.self)
        print("TOTAL SET COUNT: \(wholeSets.count)")
        print("TOTAL WORKOUT COUNT: \(d)")
        let wholeWorkouts = DBHandler.shared.realm.objects(Workout.self)
        print("TOTAL WORKOUT COUNT: \(wholeWorkouts.count)")
    }
    
    deinit {
        self.token?.invalidate()
    }
}

// MARK: Setup

extension TodayWorkoutViewController {
    private func setup() {
        view.backgroundColor = .groupTableViewBackground
        title = "오늘의 운동"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.backgroundColor = .groupTableViewBackground
            navigationBar.barTintColor = .groupTableViewBackground
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView = tableView
        
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .groupTableViewBackground
        tableView.separatorColor = .clear
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.register(WorkoutTableViewCell.self)
    }

    private func addNotificationBlock() {
        let workouts = workoutsOfDay.workouts
        token = workouts.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.deleteRows(
                        at: deletions.map { IndexPath(row: $0, section: 0)},
                        with: .automatic
                    )
                    tableView.insertRows(
                        at: insertions.map{ IndexPath(row: $0, section: 0)},
                        with: .automatic
                    )
                    tableView.reloadRows(
                        at: modifications.map{ IndexPath(row: $0, section: 0)},
                        with: .automatic
                    )
                    tableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
            }
        }
    }
}

// MARK: Delegate pattern

extension TodayWorkoutViewController {
    
    @objc func reloadTableView(_ notification: Notification) {
        tableView.reloadData()
    }
}

// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsOfDay.numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TodayWorkoutTableHeaderView()
        headerView.dateLabel.text = DateFormatter.shared.string(from: workoutsOfDay.createdDateTime)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutTableViewCell.self, for: indexPath)
        let workout = workoutsOfDay.workouts[indexPath.row]
        cell.workout = workout
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                let workoutToDelete = workoutsOfDay.workouts[indexPath.row]
                DBHandler.shared.deleteWorkout(workout: workoutToDelete)
                break
            default:
                break
        }
    }
}

// MARK: TableView Delegate

extension TodayWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workoutsOfToday = self.workoutsOfDay else { return }
        let vc = WorkoutAddViewController()
        let workout = workoutsOfToday.workouts[indexPath.row]
        vc.workoutId = workout.id
        DispatchQueue.main.async{
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
// TODO:- If there is workout here, the add vc make the fields filled
