//
//  AddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import SnapKit
//import EasyTipView

final class WorkoutAddViewController: BaseViewController {
    
    // MARK: Model
    
    private var shouldAddWorkout: Bool = false {
        didSet {
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = shouldAddWorkout
            }
        }
    }
    
    var workout: Workout? {
        didSet {
            guard let workout = self.workout else { return }
            tempWorkout = workout.copy() as! Workout
        }
    }
    
    var tempWorkout = Workout() {
        didSet {
            headerView.workout = tempWorkout
            tableView.reloadData()
            view.layoutIfNeeded()
        }
    }
    
    var workoutsOfDayId: String!
    
    var recentWorkouts: Results<Workout>!
    
    // MARK: View
    
    private var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        
        if #available(iOS 13.0, *) {
            let handleView = UIView()
            handleView.backgroundColor = .lightGray
            bar.addSubview(handleView)
            handleView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(5)
                make.width.equalTo(40)
            }
            handleView.clipsToBounds = true
            handleView.layer.cornerRadius = 3
        } else {
            // TODO: under iOS 13
        }
        
        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()
    
    let headerView = WorkoutAddHeaderView()
    
    let tableView = UITableView()
    
    let footerView = WorkoutSetAddFooterView()
    
    let workoutAddButton = UIButton()
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: View Life Cycle
    
    override func setup() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
//        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .white
        
        tableView.tableFooterView = footerView
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .interactive
        footerView.frame.size.height = Size.Cell.footerHeight
        
        workoutAddButton.setBackgroundColor(.tintColor, for: .normal)
        workoutAddButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.7), for: .highlighted)
        workoutAddButton.setBackgroundColor(.lightGray, for: .disabled)
        workoutAddButton.setTitle("완료", for: .normal)
        workoutAddButton.titleLabel?.textAlignment = .center
        workoutAddButton.titleLabel?.font = .smallBoldTitle
        workoutAddButton.clipsToBounds = true
        workoutAddButton.layer.cornerRadius = 10
        
        view.addSubview(navigationBar)
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(workoutAddButton)
        
        self.navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        self.workoutAddButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Size.addButtonHeight)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.workoutAddButton.snp.top)
        }
        
        // MARK: Only for first time
        //        var preferences = EasyTipView.Preferences()
        //        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        //        preferences.drawing.foregroundColor = UIColor.white
        //        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        //        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        //
        //        self.tipView = EasyTipView(text: "Some text", preferences: preferences)
        //
        //        EasyTipView.show(forView: self,
        //                         withinSuperview: self.superview!,
        //                         text: "Tip view inside the navigation controller's view. Tap to dismiss!",
        //                         preferences: preferences,
        //                         delegate: nil)
        //        tipView.show(forView: sender, withinSuperview: self.view)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCollectionView()
        addTargets()
        addObserverForKeyboard()
        
        headerView.nameTextField.becomeFirstResponder()
    }
    
    deinit {
        print("vc deinit - AddVCdeinited")
        print("vc deinit - AddVCdeinited")
        print("vc deinit - AddVCdeinited")
        print("vc deinit - AddVCdeinited")
        print("vc deinit - AddVCdeinited")
    }
    
    override func viewWillLayoutSubviews() {
//        guard let workout = tempWorkout else { return }
        headerView.partButton.part = tempWorkout.part
    }
}

// MARK: Setup functions

extension WorkoutAddViewController {
    
    private func configureTableView() {
        tableView.contentInset.top = Inset.scrollViewTopInset
        tableView.contentInset.bottom = Inset.scrollViewBottomInset
        tableView.rowHeight = Size.Cell.rowHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorkoutSetTableViewCell.self)
    }
    
    private func configureCollectionView() {
        recentWorkouts = DBHandler.shared.fetchRecentObjects(ofType: Workout.self)
        
        if let layout = headerView.recentWorkoutCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
//            layout.estimatedItemSize = CGSize(width: 80,
//                                              height: Size.recentCollectionViewHeight)
        }
        
        headerView.recentWorkoutCollectionView.decelerationRate = .init(rawValue: 0.2)
        headerView.recentWorkoutCollectionView.register(RecentWorkoutCollectionViewCell.self)
        headerView.recentWorkoutCollectionView.delegate = self
        headerView.recentWorkoutCollectionView.dataSource = self
    }
    
    private func addTargets() {
        headerView.partButton.addTarget(
            self, action: #selector(showActionSheet(_:)), for: .touchUpInside
        )
        
        footerView.workoutSetAddButton.addTarget(
            self, action: #selector(workoutSetDidAdded(_:)), for: .touchUpInside
        )
        
        workoutAddButton.addTarget(
            self, action: #selector(addWorkout(_:)), for: .touchUpInside
        )
    }
}

// MARK: objc functions

extension WorkoutAddViewController {
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        headerView.nameTextField.resignFirstResponder()
        //TODO: set resignFirstResponder?
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addWorkout(_ sender: UIBarButtonItem) {
        textFieldDidEndEditing(headerView.nameTextField)
        if tempWorkout.name == "" {
            showBasicAlert(title: "운동 이름을 입력하세요.", message: "운동 이름을 입력해야 등록이 가능합니다.")
            return
        }
        if workout == nil {
            // save tempWorkout to DB
            let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self, forPrimaryKey: self.workoutsOfDayId)
            
            DBHandler.shared.write {
                workoutsOfDay?.workouts.append(tempWorkout)
            }
        } else {
            // copy everything from tempWorkout to origin workout
            DBHandler.shared.write {
                workout?.copy(from: tempWorkout)
            }
        }
//        if self.workoutId == nil {
//            // create new workout data
//            let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self, forPrimaryKey: self.workoutsOfDayId)
//
//            DBHandler.shared.write {
//                workoutsOfDay?.workouts.append(workout)
//            }
//
//        } else {
//            // ??????????????
//            // ??????????????
//            // ??????????????
//            // ??????????????
//            // ??????????????
//            // ??????????????
//            // ??????????????
//            // update origin data
//            guard let originWorkout = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: workoutId!) else { return }
//            DBHandler.shared.write {
//                originWorkout.copy(from: workout)
//            }
//        }
//        self.postNotification(.WorkoutDidModifiedNotification)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func workoutSetDidAdded(_ sender: UIButton? = nil) {
        let newWorkoutSet = WorkoutSet()
        let targetIndexPath = IndexPath(row: tempWorkout.numberOfSets, section: 0)
        
        tempWorkout.sets.append(newWorkoutSet)
        tableView.insertRows(at: [targetIndexPath], with: .automatic)
        tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
    }
    
    @objc func showActionSheet(_ sender: UIButton) {
        
        var actions = [UIAlertAction]()
        
        Part.allCases.forEach { part in
            let action = UIAlertAction(title: part.description,
                                       style: part == .none ? .destructive : .default,
                                       handler: { [weak self] _ in self?.setWorkoutPart(part: part)})
            actions.append(action)
        }
        
        actions.append(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        showActionSheet(title: "파트 설정", message: nil, actions: actions)
    }
    
    private func setWorkoutPart(part: Part) {
        // MARK: 더 좋은 방법이 없을 까...?!
        
        tempWorkout.part = part
        headerView.partButton.part = part
    }
}

// MARK: Notification for Keyboard

extension WorkoutAddViewController {
    func addObserverForKeyboard() {
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillShowNotification,
                         object: nil,
                         queue: OperationQueue.main) { [weak self] noti in
                            guard let self = self else { return }
                            guard let userInfo = noti.userInfo else { return }
                            guard let bounds = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                            
                            let height = bounds.height
                            self.workoutAddButton.snp.remakeConstraints { make in
                                make.bottom.equalToSuperview().offset(-height)
                                make.leading.trailing.equalToSuperview()
                                make.height.equalTo(Size.addButtonHeight)
                            }
                            
                            UIView.animate(withDuration: 0.5) {
                                self.view.layoutIfNeeded()
                            }
        }
        
        NotificationCenter
            .default
            .addObserver(forName: UIResponder.keyboardWillHideNotification,
                         object: nil,
                         queue: OperationQueue.main) { [weak self] noti in
                            guard let self = self else { return }
                            self.workoutAddButton.snp.remakeConstraints { make in
                                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                                make.leading.trailing.equalToSuperview()
                                make.height.equalTo(Size.addButtonHeight)
                            }
                            UIView.animate(withDuration: 0.5) {
                                self.view.layoutIfNeeded()
                            }
        }
    }
}


// MARK: TableView DataSource

extension WorkoutAddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempWorkout.numberOfSets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workoutSet = tempWorkout.sets[indexPath.row]
        
        cell.workoutSet = workoutSet
        cell.setCountLabel.text = "\(indexPath.row + 1)"
        cell.degreeCircleView.clipsToBounds = true
        cell.degreeCircleView.layer.cornerRadius = cell.degreeCircleView.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                self.tempWorkout.sets.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                tableView.reloadData()
                break
            default:
                break
        }
    }
}

// MARK: TableView Delegate

extension WorkoutAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: CollectionView Delegate

extension WorkoutAddViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWorkout = recentWorkouts[indexPath.item]
        print("tempWorkout1: \(tempWorkout.name)")
        tempWorkout = selectedWorkout.copy() as! Workout
        print("tempWorkout2: \(tempWorkout.name)")
    }
}

// MARK: CollectionView DataSource

extension WorkoutAddViewController: UICollectionViewDataSource {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentWorkouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecentWorkoutCollectionViewCell.self, for: indexPath)
        let workout = self.recentWorkouts[indexPath.item]
//
//        boldBodyfontWidthsCache[indexPath] = workout.name.size(withAttributes: [
//            NSAttributedString.Key.font : UIFont.boldBody
//        ])
        
        cell.workout = workout
        return cell
    }
}

// MARK: CollectionView Delegate Flow Layout

extension WorkoutAddViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let workout = recentWorkouts[indexPath.item]
        let workoutName = workout.name
        let itemSize = workoutName.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldBody
        ])
        
        let extraWidth: CGFloat = 30

        return CGSize(width: itemSize.width + extraWidth,
                      height: Size.recentCollectionViewHeight)
    }
}


// MARK: TextField Delegate

extension WorkoutAddViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // have to write in Realm transaction
        DBHandler.shared.write {
            self.tempWorkout.name = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.tempWorkout.numberOfSets == 0 {
            workoutSetDidAdded()
        }
        return true
    }
}
