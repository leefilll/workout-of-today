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
import Hero

final class TodayWorkoutViewController: UIViewController {
    
    // properties
    private var workoutsOfToday: WorkoutsOfDay?
   
    private let realm = try! Realm()
    
    
    // UI
    var tableView: UITableView!
    
//    private var workoutAddButton : UIButton!
    
    
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
        
//        self.workoutAddButton.addTarget(self,
//                                   action: #selector(addWorkout(_:)),
//                                   for: .touchUpInside)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addWorkout(_ sender: UIButton) {
        guard let workoutsOfToday = self.workoutsOfToday else { return }
        let vc = AddWorkoutViewController()
        let newWorkout = Workout()
        self.realm.writeToRealm {
            workoutsOfToday.workouts.append(newWorkout)
        }
        vc.workout = newWorkout
        self.present(vc, animated: true, completion: nil)
    }
}


extension TodayWorkoutViewController {
    private func setup() {
        self.view.backgroundColor = .white
        
        let headerView = HeaderView()
        headerView.frame.size.height = 200
        self.tableView = UITableView()
        self.tableView.tableHeaderView = headerView        
        
//        self.workoutAddButton = UIButton()
//        self.workoutAddButton.backgroundColor = .tintColor
//        self.workoutAddButton.setTitle("운동 추가", for: .normal)

        self.view.addSubview(self.tableView)
//        self.view.addSubview(self.workoutAddButton)
//
//        self.workoutAddButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(55)
//        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(self.workoutAddButton.snp.top)
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
        }
    }
    
    private func configureTableView() {
        self.tableView.separatorColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(WorkoutsOfTodayTableViewCell.self,
                                forCellReuseIdentifier: String(describing: WorkoutsOfTodayTableViewCell.self))
//        self.tableView.register(TodayWorkoutTableViewCell.self, forCellReuseIdentifier: String(describing: TodayWorkoutTableViewCell.self))
        self.tableView.register(AddTodayWorkoutTableViewCell.self, forCellReuseIdentifier: String(describing: AddTodayWorkoutTableViewCell.self))
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
    
    private func addObserverToNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addWorkoutViewControllerDidDismissed(_:)),
                                               name: NSNotification.Name.ModalDidDisMissedNotification,
                                               object: nil)
    }
    
    @objc func addWorkoutViewControllerDidDismissed(_ notification: Notification) {

        guard let workoutsOfToday = self.workoutsOfToday else { return }
        if let workoutPrimaryKey = notification.userInfo?["PrimaryKey"] as? String,
            let addedWorkout = self.realm.object(ofType: Workout.self,
                                                 forPrimaryKey: workoutPrimaryKey){
            self.realm.writeToRealm {
                workoutsOfToday.workouts.append(addedWorkout)
            }
            self.tableView.reloadData()
            let countOfWorkouts = workoutsOfToday.countOfWorkouts
            let targetIndexPath = IndexPath(row: countOfWorkouts - 1, section: 0)
            self.tableView.scrollToRow(at: targetIndexPath, at: .middle, animated: true)
            
        } else {
            
            
        }
    }
}


// MARK: TableView DataSource
extension TodayWorkoutViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAddingCell(section: section) {
            return 1
        } else {
            guard let workoutsOfToday = self.workoutsOfToday else { return 0 }
            return workoutsOfToday.countOfWorkouts
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAddingCell(section: indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddTodayWorkoutTableViewCell.self), for: indexPath) as! AddTodayWorkoutTableViewCell
            return cell
        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodayWorkoutTableViewCell.self), for: indexPath) as! TodayWorkoutTableViewCell
//            guard let workouts = self.workoutsOfToday else { fatalError() }
//            let workout = workouts.workouts[indexPath.row]
//            cell.workout = workout
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorkoutsOfTodayTableViewCell.self), for: indexPath) as! WorkoutsOfTodayTableViewCell
            guard let workoutsOfToday = self.workoutsOfToday else { fatalError() }
            let workout = workoutsOfToday.workouts[indexPath.row]
            cell.workout = workout
            return cell
        }
    }
    
    private func isAddingCell(section: Int) -> Bool {
        if section == 0 {
            return false
        } else {
            return true
        }
    }
}


// MARK: TableView Delegate
extension TodayWorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isAddingCell(section: indexPath.section) {
            return 100
        } else {
//            return UITableView.automaticDimension
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if isAddingCell(section: indexPath.section) {
            return 100
        } else {
//            return UITableView.automaticDimension
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
            let workoutsOfToday = self.workoutsOfToday else { return }
        
        let heroId = "\(indexPath)"
        cell.hero.id = heroId
        
        let vc = AddWorkoutViewController()
        vc.hero.isEnabled = true
        vc.contentView.heroID = heroId
        vc.modalPresentationStyle = .overCurrentContext
        
        if isAddingCell(section: indexPath.section) {
            vc.isExist = false
            self.present(vc, animated: true, completion: nil)
        } else {
            let workout = workoutsOfToday.workouts[indexPath.row]
            vc.isExist = true
            vc.workout = workout
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
// TODO:- If there is workout here, the add vc make the fields filled

