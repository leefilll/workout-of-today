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

final class TodayWorkoutViewController: BasicViewController, Feedbackable {
    
    // MARK: Model
    
    private let slideTransitioningDelegate =  SlideTransitioningDelegate(heightRatio: 0.90)
    
    private let popupTransitioningDelegate = PopupTransitioningDelegate(height: 230)
    
    private let popupTransitioningDelegateForNote = PopupTransitioningDelegate(height: 300)
    
    private let popupTransitioningDelegateForTemplate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.50)
    
    var workoutsOfDay: WorkoutsOfDay?
    
    override var navigationBarTitle: String {
        return "오늘의 운동"
    }
    
    private var selectedIndexPath: IndexPath?
    
    // MARK: View
    
    private weak var tableView: UITableView!
    
    private weak var workoutAddButton: UIButton!
    
    private weak var tableHeaderView: TodayWorkoutTableHeaderView!
    
    // MARK: View Life Cycle
    
    deinit {
        print(String(describing: self) + " " + #function)
    }
    
    override func setup() {
        setupTableView()
        setupWorkoutAddButton()
        prepareFeedback()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureWorkoutAddButton()
    }
    
    
    private func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset.bottom = Size.addButtonHeight + 10
        tableView.alwaysBounceVertical = true
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = Size.Cell.headerHeight
        tableView.estimatedSectionHeaderHeight = Size.Cell.headerHeight
        tableView.sectionFooterHeight = Size.Cell.footerHeight
        tableView.estimatedSectionFooterHeight = Size.Cell.footerHeight
        tableView.rowHeight = Size.Cell.rowHeight
        tableView.estimatedRowHeight = Size.Cell.rowHeight
        view.insertSubview(tableView, at: 0)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
        
        self.tableView = tableView
    }
    
    private func setupWorkoutAddButton() {
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
    
    override func setupFeedbackGenerator() {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        impactFeedbackGenerator?.prepare()
        selectionFeedbackGenerator?.prepare()
    }
    
    // MARK: WorkoutDidModified Notifications
    
    override func registerNotifications() {
        registerNotification(.WorkoutDidAdded) { [weak self] note in
            guard let strongSelf = self else { return }
            if let workoutsOfDay = strongSelf.workoutsOfDay {
                let targetSection = workoutsOfDay.numberOfWorkouts - 1
                let targetIndexPath = IndexPath(row: NSNotFound, section: targetSection)
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.insertSections([targetSection], with: .fade)
                strongSelf.tableView.endUpdates()
                strongSelf.tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
            } else {
                let keyFromDate = DateFormatter.shared.keyStringFromNow
                guard let newWorkoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self, forPrimaryKey: keyFromDate) else { fatalError() }
                strongSelf.workoutsOfDay = newWorkoutsOfDay
                strongSelf.tableHeaderView.workoutNoteButton.isHidden = false
                strongSelf.tableView.reloadData()
            }
        }
        
        registerNotification(.WorkoutDidDeleted) { [weak self] note in
            guard let strongSelf = self else { return }
            if let workoutsOfDay = strongSelf.workoutsOfDay {
                if workoutsOfDay.numberOfWorkouts == 0 {
                    DBHandler.shared.delete(object: workoutsOfDay)
                    strongSelf.tableHeaderView.workoutNoteButton.isHidden = true
                    strongSelf.workoutsOfDay = nil
                }
            }
            strongSelf.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        let tableHeaderView = TodayWorkoutTableHeaderView()
        tableHeaderView.titleLabel.text = DateFormatter.shared.string(from: Date.now)
        tableHeaderView.frame.size.height = 50
        tableHeaderView.frame.size.width = tableView.bounds.width
        tableHeaderView.workoutNoteButton.addTarget(self, action: #selector(workoutNoteButtonDidTapped(_:)), for: .touchUpInside)
        if let workoutsOfDay = workoutsOfDay {
            if workoutsOfDay.numberOfWorkouts == 0 {
                tableHeaderView.workoutNoteButton.isHidden = true
            }
        }
        
        tableView.tableHeaderView = tableHeaderView
        self.tableHeaderView = tableHeaderView
        
        //        tableView.emptyDataSetSource = self
        //        tableView.emptyDataSetDelegate = self
        
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
    
    override func keyboardWillShow(in bounds: CGRect?) {
        guard let keyboardMinY = bounds?.minY,
            let selectedIndexPath = selectedIndexPath else { return }
        let rectForSelectedCell = tableView.rectForRow(at: selectedIndexPath)
        let rectInScreen = tableView.convert(rectForSelectedCell, to: view)
        let extraHeight: CGFloat = 5
        
        if keyboardMinY < rectInScreen.maxY + extraHeight {
            let overlappedHeight = rectInScreen.maxY + extraHeight - keyboardMinY
            tableView.contentInset.bottom += overlappedHeight
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                self.tableView.scrollToRow(at: selectedIndexPath, at: .middle, animated: true)
            }
        }
    }
    
    override func keyboardWillHide() {
        tableView.contentInset.bottom = Size.addButtonHeight + 10
        //        selectedIndexPath = nil
    }
}

// MARK: objc functions

extension TodayWorkoutViewController {
    @objc
    private func workoutSetAddButtonDidTapped(_ sender: UIButton) {
        guard let workoutsOfDay = workoutsOfDay else { return }
        let section = sender.tag
        let workout = workoutsOfDay.workouts[section]
        let newWorkoutSet = WorkoutSet()
        let targetIndexPath = IndexPath(row: workout.numberOfSets, section: section)
        DBHandler.shared.write {
            workout.sets.append(newWorkoutSet)
        }
        selectionFeedbackGenerator?.selectionChanged()
        tableView.insertRows(at: [targetIndexPath], with: .none)
    }
    
    // MARK: Present WorkoutAdd VC
    
    @objc
    private func workoutAddButtonDidTapped(_ sender: UIButton) {
        let addWorkoutVC = TodayAddWorkoutViewController(nibName: "TodayAddWorkoutViewController", bundle: nil)
        addWorkoutVC.workoutsOfDay = workoutsOfDay
        addWorkoutVC.modalPresentationStyle = .custom
        addWorkoutVC.transitioningDelegate = slideTransitioningDelegate
//        addWorkoutVC.delegate = self
        selectionFeedbackGenerator?.selectionChanged()
        present(addWorkoutVC, animated: true, completion: nil)
    }
    
    @objc
    private func workoutSectionHeaderDidBeginPressed(_ sender: UILongPressGestureRecognizer) {
        // MARK: using tag for knowing sections
        guard let section = sender.view?.tag,
            let workoutToDelete = workoutsOfDay?.workouts[section]
            else {
                print("Error occurs during delete object")
                return
        }
        
        let warningAlertVC = WarningAlertViewController(title: "운동을 삭제할까요?", message: "\(workoutToDelete.name) 운동과 모든 세트 정보를 삭제합니다.\n이 동작은 되돌릴 수 없습니다.", primaryKey: workoutToDelete.id)
//        warningAlertVC.delegate = self
        warningAlertVC.modalPresentationStyle = .custom
        warningAlertVC.transitioningDelegate = popupTransitioningDelegate
        
        if let presented = self.presentedViewController {
            presented.removeFromParent()
        }
        
        if presentedViewController == nil {
            impactFeedbackGenerator?.impactOccurred()
            self.present(warningAlertVC, animated: true, completion: nil)
        }
    }
    
    @objc
    private func workoutNoteButtonDidTapped(_ sender: UIButton) {
        guard let workoutsOfDay = workoutsOfDay else { return }
        
        let noteVC = TodayWorkoutNoteViewController(nibName: "TodayWorkoutNoteViewController", bundle: nil)
        noteVC.workoutsOfDay = workoutsOfDay
        noteVC.modalPresentationStyle = .custom
        noteVC.transitioningDelegate = popupTransitioningDelegateForNote
        selectionFeedbackGenerator?.selectionChanged()
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
        cell.indexPath = indexPath
        cell.delegate = self
        
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
                selectionFeedbackGenerator?.selectionChanged()
                
                tableView.deleteRows(at: [indexPath], with: .bottom)
                UIView.setAnimationsEnabled(false)
                tableView.beginUpdates()
                tableView.reloadData()
                tableView.endUpdates()
                UIView.setAnimationsEnabled(true)
            default:
                break
        }
    }
}

// MARK: TableView Delegate

extension TodayWorkoutViewController: UITableViewDelegate {
    
    // MARK: Header
    // Note that view.tag means section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let workoutsOfDay = workoutsOfDay else { return nil }
        let workout = workoutsOfDay.workouts[section]
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(workoutSectionHeaderDidBeginPressed(_:)))
        let headerView = tableView.dequeueReusableHeaderFooterView(TodayWorkoutSectionHeaderView.self)
        headerView.tag = section
        headerView.workout = workout
        headerView.addGestureRecognizer(longPressGestureRecognizer)
        
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}


// MARK: WorkoutDidModified Delegate
//
//extension TodayWorkoutViewController: WorkoutDidModiFieid {
//    func workoutDidDeleted() {
//        if let workoutsOfDay = workoutsOfDay {
//            if workoutsOfDay.numberOfWorkouts == 0 {
//                DBHandler.shared.delete(object: workoutsOfDay)
//                tableHeaderView.workoutNoteButton.isHidden = true
//                self.workoutsOfDay = nil
//            }
//        }
//        tableView.reloadData()
//    }
//
//    func workoutDidAdded() {
//        guard let workoutsOfDay = workoutsOfDay else { fatalError() }
//        let targetSection = workoutsOfDay.numberOfWorkouts - 1
//        let targetIndexPath = IndexPath(row: NSNotFound, section: targetSection)
//        tableView.beginUpdates()
//        tableView.insertSections([targetSection], with: .fade)
//        tableView.endUpdates()
//        tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
//    }
//
//    func firstWorkoutDidAdded(at workoutsOfDay: WorkoutsOfDay) {
//        self.workoutsOfDay = workoutsOfDay
//        tableHeaderView.workoutNoteButton.isHidden = false
//        tableView.reloadData()
//    }
//}

// MARK: WorkoutSetDidBeginEditing Delegate

extension TodayWorkoutViewController: WorkoutSetDidBeginEditing {
    func workoutSetDidBeginEditing(at indexPath: IndexPath?) {
        selectedIndexPath = indexPath
    }
}

// MARK: for Empty tableView

extension TodayWorkoutViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
}
