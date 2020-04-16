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
        self.addObserverToNotificationCenter(.WorkoutDidAddedNotification,
                                             selector: #selector(reloadTableView(_:)))
        
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
        wholeSets.forEach{ set in
            print("\(set.weight) - \(set.reps)")
        }
        print("TOTAL SET COUNT: \(wholeSets.count)")
        print("TOTAL WORKOUT COUNT: \(d)")
        let wholeWorkouts = DBHandler.shared.realm.objects(Workout.self)
        print("TOTAL WORKOUT COUNT: \(wholeWorkouts.count)")
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Setup

extension TodayWorkoutViewController {
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
//        self.view.backgroundColor = .white
        
        self.title = "오늘의 운동"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.backgroundColor = .groupTableViewBackground
            navigationBar.barTintColor = .groupTableViewBackground
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
        
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
        }
    }
    
    private func configureTableView() {
        self.tableView.backgroundColor = .groupTableViewBackground
//        self.tableView.backgroundColor = .clear
        self.tableView.separatorColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delaysContentTouches = false
        self.tableView.register(WorkoutTableViewCell.self)
    }
}

// MARK: Delegate pattern

extension TodayWorkoutViewController {
    
    @objc func reloadTableView(_ notification: Notification) {
        self.tableView.reloadData()
    }
}

// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutsOfDay.numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TodayWorkoutTableHeaderView()
        headerView.dateLabel.text = DateFormatter.shared.string(from: self.workoutsOfDay.createdDateTime)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutTableViewCell.self, for: indexPath)
        let workout = self.workoutsOfDay.workouts[indexPath.row]
        cell.workout = workout
        return cell
    }
}

// MARK: TableView Delegate

extension TodayWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        cell.containerView.backgroundColor = .white
//        cell.containerView.backgroundColor = UIColor.partColor(cell.workout?.part ?? 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workoutsOfToday = self.workoutsOfDay else { return }
        let vc = WorkoutAddViewController()
        let workout = workoutsOfToday.workouts[indexPath.row]
        vc.workoutId = workout.id
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// TODO:- If there is workout here, the add vc make the fields filled
