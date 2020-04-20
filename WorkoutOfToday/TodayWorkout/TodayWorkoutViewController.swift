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
    
    weak var tableHeaderView: TodayWorkoutTableHeaderView!
    
    // MARK: View Life Cycle
    
    deinit {
        self.token?.invalidate()
        print(String(describing: self) + " " + #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureWorkoutAddButton()
        
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
        setupTableView()
        setupWorkoutAddButton()
        setupConstraint()
    }
    
    fileprivate func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset.bottom = Size.addButtonHeight + 10
        
        let tableHeaderView = TodayWorkoutTableHeaderView()
        tableHeaderView.frame.size.height = 40
        tableView.tableHeaderView = tableHeaderView
        
        self.tableHeaderView = tableHeaderView
        self.tableView = tableView
        view.addSubview(self.tableView)
    }
    
    fileprivate func setupWorkoutAddButton() {
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

        self.workoutAddButton = workoutAddButton
        view.addSubview(self.workoutAddButton)
    }
    
    fileprivate func setupConstraint() {
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
    
    fileprivate func configureTableView() {
        tableView.backgroundColor = .defaultBackgroundColor
        tableView.sectionHeaderHeight = Size.Cell.headerHeight
        tableView.sectionFooterHeight = Size.Cell.footerHeight
        tableView.rowHeight = Size.Cell.rowHeight
        
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WorkoutSetTableViewCell.self)
        tableView.register(TodayWorkoutSectionHeaderView.self)
        tableView.register(WorkoutSetAddFooterView.self)
    }
    
    
    private func configureWorkoutAddButton() {
        workoutAddButton.addTarget(self,
                                   action: #selector(workoutAddButtonDidTapped(_:)),
                                   for: .touchUpInside)
    }
}


// MARK: objc functions

extension TodayWorkoutViewController {
    @objc
    fileprivate func workoutSetAddButtonDidTapped(_ sender: UIButton) {
        let section = sender.tag
        let workout = workoutsOfDay.workouts[section]
        let newWorkoutSet = WorkoutSet()
        let targetIndexPath = IndexPath(row: workout.numberOfSets, section: section)
        DBHandler.shared.write {
            workout.sets.append(newWorkoutSet)
        }
        tableView.insertRows(at: [targetIndexPath], with: .automatic)
    }
    
    // MARK: Present WorkoutAdd VC
    
    @objc
    fileprivate func workoutAddButtonDidTapped(_ sender: UIButton) {
        let vc = TodayAddWorkoutViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutsOfDay.workouts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workout = workoutsOfDay.workouts[section]
        return workout.numberOfSets
//        return workoutsOfDay.numberOfWorkouts
    }
    
  
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let workout = workoutsOfDay.workouts[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(TodayWorkoutSectionHeaderView.self)
        headerView.workout = workout
        return headerView
    }
    
    // MARK: Footer
    // Note that buttton.tag means section
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(WorkoutSetAddFooterView.self)
        
        footerView.workoutSetAddButton.tag = section
        footerView.workoutSetAddButton.addTarget(self,
                                                 action: #selector(workoutSetAddButtonDidTapped(_:)),
                                                 for: .touchUpInside)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let setCount = indexPath.row + 1
        cell.setCountLabel.text = "\(setCount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                let workout = workoutsOfDay.workouts[indexPath.section]
                let setToDelete = workout.sets[indexPath.row]
                DBHandler.shared.delete(object: setToDelete)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                tableView.reloadSections([indexPath.section], with: .none)
                break
            default:
                break
        }
    }
}

// MARK: TableView Delegate

extension TodayWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let workoutsOfToday = self.workoutsOfDay else { return }
//        let vc = WorkoutAddViewController()
//        let workout = workoutsOfToday.workouts[indexPath.row]
//        vc.workout = workout
//        DispatchQueue.main.async{
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
// TODO:- If there is workout here, the add vc make the fields filled


extension TodayWorkoutViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return PopupPresentationController(presentedViewController: presented, presenting: presenting)
//    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimationController(animationDuration: 0.5, animationType: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimationController(animationDuration: 0.5, animationType: .dismiss)
    }
}
