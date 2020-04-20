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

final class TodayWorkoutViewController: BaseViewController {
    
    // MARK: Model
    
    var workoutsOfDay: WorkoutsOfDay!
    
    override var navigationBarTitle: String {
        return "오늘의 운동"
    }
    
    // MARK: View
    
    weak var tableView: UITableView!
    
    weak var workoutAddButton: UIButton!
    
    // MARK: View Life Cycle
    
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
    
    override func setup() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset.bottom = Size.addButtonHeight + 10
        
        
        let workoutAddButton = UIButton()
        workoutAddButton.setBackgroundColor(.tintColor, for: .normal)
        workoutAddButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.7),
                                            for: .highlighted)
        workoutAddButton.setBackgroundColor(.lightGray, for: .disabled)
        workoutAddButton.setTitle("운동 추가", for: .normal)
        workoutAddButton.titleLabel?.textAlignment = .center
        workoutAddButton.titleLabel?.font = .smallBoldTitle
        workoutAddButton.clipsToBounds = true
        workoutAddButton.layer.cornerRadius = 10
        
        self.tableView = tableView
        self.workoutAddButton = workoutAddButton
        
        view.addSubview(tableView)
        view.addSubview(workoutAddButton)
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
        
        self.workoutAddButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(Size.addButtonHeight)
        }
    }
    
    deinit {
        self.token?.invalidate()
    }
}

// MARK: Setup

extension TodayWorkoutViewController {
    
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
        let workout = workoutsOfDay.workouts[section]
        return workout.numberOfSets
//        return workoutsOfDay.numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let workout = workoutsOfDay.workouts[section]
        
        let headerView = WorkoutHeaderView()
        headerView.workout = workout

//        let headerView = TableHeaderView()
//        headerView.label.text = DateFormatter.shared.string(from: workoutsOfDay.createdDateTime)
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
//        return UITableView.automaticDimension
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workoutsOfToday = self.workoutsOfDay else { return }
        let vc = WorkoutAddViewController()
        let workout = workoutsOfToday.workouts[indexPath.row]
        vc.workout = workout
//        vc.workoutId = workout.id
        DispatchQueue.main.async{
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
// TODO:- If there is workout here, the add vc make the fields filled
