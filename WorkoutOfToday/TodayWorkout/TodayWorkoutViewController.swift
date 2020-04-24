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
import Presentr

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
    
    // MARK: Presenter
    
     let presenter: Presentr = {
           let width = ModalSize.full
           let height = ModalSize.fluid(percentage: 0.20)
           let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
           let customType = PresentationType.custom(width: width, height: height, center: center)

           let customPresenter = Presentr(presentationType: customType)
           customPresenter.transitionType = .coverVerticalFromTop
           customPresenter.dismissTransitionType = .crossDissolve
           customPresenter.roundCorners = false
           customPresenter.backgroundColor = .green
           customPresenter.backgroundOpacity = 0.5
           customPresenter.dismissOnSwipe = true
           customPresenter.dismissOnSwipeDirection = .top
           return customPresenter
       }()
    
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
    }
    
    
    
    fileprivate func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset.bottom = Size.addButtonHeight + 10
        
        
        // FIXME: TableHeaderView
        
        
//        let tableHeaderView = TodayWorkoutTableHeaderView()
//        tableHeaderView.titleLabel.text = workoutsOfDay.dateAndWeekdayString
//        tableView.tableHeaderView = tableHeaderView
//        tableHeaderView.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.height.equalTo(50)
//        }
//
//        self.tableHeaderView = tableHeaderView
        
//        view.addSubview(self.tableView)
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
        workoutAddButton.layer.cornerRadius = 10

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
        tableView.backgroundColor = .defaultBackgroundColor
        tableView.sectionHeaderHeight = Size.Cell.headerHeight
        tableView.sectionFooterHeight = Size.Cell.footerHeight
        tableView.rowHeight = Size.Cell.rowHeight
        
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
        token = workoutsOfDay.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
                case .change:
                    let targetSection = self.workoutsOfDay.numberOfWorkouts - 1
                    print("targetSection:  \(targetSection)")
                    print("targetSection:  \(targetSection)")
                    print("targetSection:  \(targetSection)")
                    print("targetSection:  \(targetSection)")
                    
                    let targetIndexPath = IndexPath(row: NSNotFound, section: targetSection)
                    self.tableView.beginUpdates()
                    self.tableView.insertSections([targetSection],
                                                  with: .fade)
                    self.tableView.endUpdates()
                    self.tableView.scrollToRow(at: targetIndexPath,
                                               at: .top,
                                               animated: true)
                case .error(let error):
                    print("An error occurred: \(error)")
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
        let section = sender.tag
        let workout = workoutsOfDay.workouts[section]
        let newWorkoutSet = WorkoutSet()
        let targetIndexPath = IndexPath(row: workout.numberOfSets, section: section)
        DBHandler.shared.write {
            workout.sets.append(newWorkoutSet)
        }
        self.tableView.insertRows(at: [targetIndexPath], with: .automatic)
        tableView.setNeedsUpdateConstraints()
    }
    
    // MARK: Present WorkoutAdd VC
    
    @objc
    fileprivate func workoutAddButtonDidTapped(_ sender: UIButton) {
        let vc = TodayAddWorkoutViewController(nibName: "TodayAddWorkoutViewController",
                                               bundle: nil)
//        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        vc.workoutsOfDay = workoutsOfDay
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    fileprivate func workoutSectionHeaderDidTapped(_ sender: UITapGestureRecognizer) {
        // MARK: using tag for knowing sections
        if let section = sender.view?.tag {
            print("section: \(section)")
            print("section: \(section)")
            print("section: \(section)")
        }
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
    }
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
                
                tableView.deleteRows(at: [indexPath], with: .none)
                self.perform(#selector(reloadData), with: nil, afterDelay: 0.1)
                //TODO: reloadSection animation
                tableView.setNeedsUpdateConstraints()
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

// MARK: Animation Delegate
//
extension TodayWorkoutViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return PopupPresentationController(presentedViewController: presented, presenting: presenting)
//    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimationController(animationDuration: 0.35, animationType: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimationController(animationDuration: 0.3, animationType: .dismiss)
    }
}
