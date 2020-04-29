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
import DZNEmptyDataSet
import IHKeyboardAvoiding

final class TodayWorkoutViewController: BaseViewController {
    
    // MARK: Model
    
    fileprivate let slideTransitioningDelegate =  SlideTransitioningDelegate(heightRatio: 0.6)
    
    fileprivate let popupTransitioningDelegate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.35)
    
    var workoutsOfDay: WorkoutsOfDay?
    
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
        addNotificationBlock()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let heightRatio: CGFloat = 0.4
//        let maxYOfButton = workoutAddButton.frame.maxY
//        let heightOfPresentedView = view.bounds.height * heightRatio
//        let minY = maxYOfButton - heightOfPresentedView
//        popupTransitioningDelegate = PopupTransitioningDelegate(widthRatio: 0.95,
//                                                                heightRatio: heightRatio,
//                                                                minY: minY)
//    }
    
    override func setup() {
        setupTableView()
        setupWorkoutAddButton()
    }
    
    fileprivate func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset.bottom = Size.addButtonHeight + 10
        
        view.insertSubview(tableView, at: 0)
        self.tableView = tableView
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
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
        workoutAddButton.layer.cornerRadius = Size.cornerRadius

        self.workoutAddButton = workoutAddButton
        view.addSubview(self.workoutAddButton)
        
        self.workoutAddButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(Size.addButtonHeight)
        }
    }
    
    fileprivate func configureTableView() {
        let tableHeaderView = TodayWorkoutTableHeaderView()
        tableHeaderView.titleLabel.text = DateFormatter.shared.string(from: Date.now)
        tableHeaderView.frame.size.height = 50
        tableHeaderView.frame.size.width = tableView.bounds.width
        tableHeaderView.workoutNoteButton.addTarget(self,
                                                    action: #selector(workoutNoteButtonDidTapped(_:)),
                                                    for: .touchUpInside)
        tableView.tableHeaderView = tableHeaderView
        self.tableHeaderView = tableHeaderView
        
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = Size.Cell.headerHeight
        tableView.estimatedSectionHeaderHeight = Size.Cell.headerHeight
        tableView.sectionFooterHeight = Size.Cell.footerHeight
        tableView.estimatedSectionFooterHeight = Size.Cell.footerHeight
        tableView.rowHeight = Size.Cell.rowHeight
        tableView.estimatedRowHeight = Size.Cell.rowHeight
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerByNib(WorkoutSetTableViewCell.self)
        tableView.registerByNib(TodayWorkoutSectionHeaderView.self)
        tableView.registerByNib(WorkoutSetAddFooterView.self)
    }
    
    private func configureWorkoutAddButton() {
        workoutAddButton.addTarget(self,
                                   action: #selector(workoutAddButtonDidTapped(_:)),
                                   for: .touchUpInside)
    }
    
    private func addNotificationBlock() {
        token = workoutsOfDay?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
                case .change(let properties):
                    guard let workoutsOfDay = self.workoutsOfDay else { return }
                    properties.forEach { property in
                        if property.name == "note" {
                            return
                        } else {
                            let targetSection = workoutsOfDay.numberOfWorkouts - 1
                            let targetIndexPath = IndexPath(row: NSNotFound, section: targetSection)
                            self.tableView.beginUpdates()
                            self.tableView.insertSections([targetSection],
                                                          with: .fade)
                            self.tableView.endUpdates()
                            self.tableView.scrollToRow(at: targetIndexPath,
                                                       at: .top,
                                                       animated: true)
                        }
                }
                case .error(let error):
                    fatalError("\(error)")
                case .deleted:
                    print("The object was deleted.")
                    self.tableView.reloadData()
            }
        }
    }
}


// MARK: objc functions

extension TodayWorkoutViewController {
    @objc
    fileprivate func workoutSetAddButtonDidTapped(_ sender: UIButton) {
        guard let workoutsOfDay = workoutsOfDay else { return }
        let section = sender.tag
        let workout = workoutsOfDay.workouts[section]
        let newWorkoutSet = WorkoutSet()
        let targetIndexPath = IndexPath(row: workout.numberOfSets, section: section)
        DBHandler.shared.write {
            workout.sets.append(newWorkoutSet)
        }
        tableView.insertRows(at: [targetIndexPath], with: .none)
    }
    
    // MARK: Present WorkoutAdd VC
    
    @objc
    fileprivate func workoutAddButtonDidTapped(_ sender: UIButton) {
        let vc = TodayAddWorkoutViewController(nibName: "TodayAddWorkoutViewController",
                                               bundle: nil)
        vc.workoutsOfDay = workoutsOfDay
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = slideTransitioningDelegate
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    fileprivate func workoutSectionHeaderDidTapped(_ sender: UITapGestureRecognizer) {
        // MARK: using tag for knowing sections
        if let section = sender.view?.tag {
            print("section: \(section)")
        }
    }
    
    @objc
    fileprivate func workoutNoteButtonDidTapped(_ sender: UIButton) {
        guard let workoutsOfDay = workoutsOfDay else { return }
        
        let noteVC = TodayWorkoutNoteViewController(nibName: "TodayWorkoutNoteViewController", bundle: nil)
        noteVC.workoutsOfDay = workoutsOfDay
        noteVC.transitioningDelegate = popupTransitioningDelegate
        noteVC.modalPresentationStyle = .custom
        KeyboardAvoiding.avoidingView = noteVC.view
        
        present(noteVC, animated: true, completion: nil)
    }
}

// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let workoutsOfDay = workoutsOfDay else { return 0 }
        return workoutsOfDay.workouts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workoutsOfDay = workoutsOfDay else { return 0 }
        let workout = workoutsOfDay.workouts[section]
        return workout.numberOfSets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workout = workoutsOfDay?.workouts[indexPath.section]
        let workoutSet = workout?.sets[indexPath.row]
        let setCount = indexPath.row + 1
        cell.countLabel.text = "\(setCount)"
        cell.workoutSet = workoutSet
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let workoutsOfDay = workoutsOfDay else { return }
        switch editingStyle {
            case .delete:
                let workout = workoutsOfDay.workouts[indexPath.section]
                let setToDelete = workout.sets[indexPath.row]
                DBHandler.shared.delete(object: setToDelete)
                
                tableView.deleteRows(at: [indexPath], with: .bottom)
                UIView.performWithoutAnimation {
                    self.tableView.reloadData()
                }
//                self.perform(#selector(reloadData), with: nil, afterDelay: 0.1)
                //TODO: reloadSection animation
//                tableView.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
                
            default:
                break
        }
    }
    
    @objc
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: TableView Delegate

extension TodayWorkoutViewController: UITableViewDelegate {
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let workoutsOfDay = workoutsOfDay else { return nil }
        let workout = workoutsOfDay.workouts[section]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(workoutSectionHeaderDidTapped(_:)))
        
        let headerView = tableView.dequeueReusableHeaderFooterView(TodayWorkoutSectionHeaderView.self)
        headerView.tag = section
        headerView.workout = workout
        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        headerView.backgroundView = backgroundView
        
        return headerView
    }
    
    // MARK: Footer
    // Note that buttton.tag means section
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(WorkoutSetAddFooterView.self)
        
        footerView.workoutSetAddButton.tag = section
        footerView.workoutSetAddButton.addTarget(
            self,
            action: #selector(workoutSetAddButtonDidTapped(_:)),
            for: .touchUpInside
        )
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        footerView.backgroundView = backgroundView
        
        return footerView
    }
    
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

// MARK: for Empty tableView

extension TodayWorkoutViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
}
