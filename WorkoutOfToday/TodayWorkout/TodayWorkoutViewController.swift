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
    
    private let slideTransitioningDelegate =  SlideTransitioningDelegate(heightRatio: 0.92)
    
    private let popupTransitioningDelegate = PopupTransitioningDelegate(height: 255)
    
    private let popupTransitioningDelegateForNote = PopupTransitioningDelegate(height: 300)
    
    private let popupTransitioningDelegateForTemplate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.50)
    
    var workouts: Results<Workout>?
    
    var notes: Results<Note>?
    
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
        
//      MARK: TEST DATA
        func makeDummy(name: String) {
            let ts = DBHandler.shared.fetchObjects(ofType: WorkoutTemplate.self)
            .filter("_name = '\(name)'")
            .first!
            
            let numOfSets = Int.random(in: 0...10)
            let day = Int.random(in: -300 ... -10)
            
            let w1 = Workout()
            w1.template = ts
            w1.created = Date.now.dateFromDays(day)

            var ss = [WorkoutSet]()

            Array(0...numOfSets).forEach { _ in
                let s1 = WorkoutSet()
                s1.reps = Int.random(in: 0...20)
                s1.weight = Double.random(in: 30...200)
                ss.append(s1)
            }

            DBHandler.shared.write {
                DBHandler.shared.realm.add(w1)
                ss.forEach { s in
                    DBHandler.shared.realm.add(s)
                    w1.sets.append(s)
                }
            }
        }
//        for _ in 0...Int.random(in: 0...200) {
//            makeDummy(name: "해머 컬")
//        }
//        for _ in 0...Int.random(in: 0...250) {
//            makeDummy(name: "런닝머신")
//        }
//        for _ in 0...Int.random(in: 0...250) {
//            makeDummy(name: "아아아아아아")
//        }
//        for _ in 0...Int.random(in: 0...150) {
//            makeDummy(name: "테스트 운동")
//        }
        
        // MARK: Fetch workouts
        workouts = DBHandler.shared.fetchObjects(ofType: Workout.self)
        .filter(Date.now.predicateForDay)
        .sorted(byKeyPath: "created")
        
        notes = DBHandler.shared.fetchObjects(ofType: Note.self)
        .filter(Date.now.predicateForDay)
        .sorted(byKeyPath: "created")
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
        workoutAddButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.8),
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
            if let workouts = strongSelf.workouts {
                let targetSection = workouts.count - 1
                let targetIndexPath = IndexPath(row: NSNotFound, section: targetSection)
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.insertSections([targetSection], with: .fade)
                strongSelf.tableView.endUpdates()
                strongSelf.tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
            }
        }
        
        registerNotification(.WorkoutDidDeleted) { [weak self] note in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        let tableHeaderView = TodayWorkoutTableHeaderView()
        tableHeaderView.titleLabel.text = DateFormatter.shared.string(from: Date.now)
        tableHeaderView.frame.size.height = 50
        tableHeaderView.frame.size.width = tableView.bounds.width
        tableHeaderView.workoutNoteButton.addTarget(self, action: #selector(workoutNoteButtonDidTapped(_:)), for: .touchUpInside)
        
        tableView.tableHeaderView = tableHeaderView
        self.tableHeaderView = tableHeaderView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
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
    }
}

// MARK: objc functions

extension TodayWorkoutViewController {
    @objc
    private func workoutSetAddButtonDidTapped(_ sender: UIButton) {
        guard let workouts = workouts else { return }
        let section = sender.tag
        let workout = workouts[section]
        let targetIndexPath = IndexPath(row: workout.numberOfSets, section: section)
        
        let newWorkoutSet = WorkoutSet()
        DBHandler.shared.write {
            DBHandler.shared.realm.add(newWorkoutSet)
            workout.sets.append(newWorkoutSet)
        }
        selectionFeedbackGenerator?.selectionChanged()
        tableView.insertRows(at: [targetIndexPath], with: .none)
    }
    
    // MARK: Present WorkoutAdd VC
    
    @objc
    private func workoutAddButtonDidTapped(_ sender: UIButton?) {
        let addWorkoutVC = DraggableNavigationController(rootViewController: TodayAddWorkoutViewController())
        addWorkoutVC.modalPresentationStyle = .custom
        addWorkoutVC.transitioningDelegate = slideTransitioningDelegate
        selectionFeedbackGenerator?.selectionChanged()
        present(addWorkoutVC, animated: true, completion: nil)
    }
    
    @objc
    private func workoutSectionHeaderDidBeginPressed(_ sender: UILongPressGestureRecognizer) {
        // MARK: using tag for knowing sections
        guard let section = sender.view?.tag,
            let workoutToDelete = workouts?[section]
            else {
                print("Error occurs during delete object")
                return
        }
        
        let warningAlertVC = WarningAlertViewController(workoutToDelete: workoutToDelete, index: section, title: "운동을 삭제할까요?", message: "\(workoutToDelete.name) 운동과 모든 세트 정보를 삭제합니다.\n이 동작은 되돌릴 수 없습니다.")
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
        let noteVC = TodayWorkoutNoteViewController(nibName: "TodayWorkoutNoteViewController", bundle: nil)
        if let note = notes?.first { noteVC.note = note }
        noteVC.modalPresentationStyle = .custom
        noteVC.transitioningDelegate = popupTransitioningDelegateForNote
        selectionFeedbackGenerator?.selectionChanged()
        present(noteVC, animated: true, completion: nil)
    }
}

// MARK: TableView DataSource

extension TodayWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let workouts = workouts else { return 0 }
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workouts = workouts else { return 0 }
        let workout = workouts[section]
        return workout.numberOfSets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workout = workouts?[indexPath.section]
        let workoutSet = workout?.sets[indexPath.row]
        let setCount = indexPath.row + 1
        
        cell.countLabel.text = "\(setCount) set"
        cell.workoutSet = workoutSet
        cell.style = workout?.style
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let workouts = workouts else { return }
        switch editingStyle {
            case .delete:
                let workout = workouts[indexPath.section]
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
        guard let workouts = workouts else { return nil }
        let workout = workouts[section]
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(workoutSectionHeaderDidBeginPressed(_:)))
        let headerView = tableView.dequeueReusableHeaderFooterView(TodayWorkoutSectionHeaderView.self)
        headerView.tag = section
//        headerView.workout = workout
        headerView.template = workout.template
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

// MARK: WorkoutSetDidBeginEditing Delegate

extension TodayWorkoutViewController: WorkoutSetDidBeginEditing {
    func workoutSetDidBeginEditing(at indexPath: IndexPath?) {
        selectedIndexPath = indexPath
    }
}

// MARK: DZNEmptyDataSet DataSource and Delegate

extension TodayWorkoutViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return workouts?.count == 0 ? true : false
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "오늘 운동이 없습니다"
        let font = UIFont.smallBoldTitle
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let str = "화면을 터치하거나 버튼을 탭하여\n운동을 추가하세요."
//        let font = UIFont.subheadline
//        let attributes = [
//            NSAttributedString.Key.font: font,
//            NSAttributedString.Key.foregroundColor: UIColor.lightGray
//        ]
//        let attributedString = NSAttributedString(string: str, attributes: attributes)
//        return attributedString
//    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        workoutAddButtonDidTapped(nil)
    }
}
