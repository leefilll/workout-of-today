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

final class WorkoutAddViewController: UIViewController {
    
    // MARK: Model
    
    private var shouldAddWorkout: Bool = false {
        didSet {
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = shouldAddWorkout
            }
        }
    }
    
    var tempWorkout: Workout?
    
    var workoutId: String?
    
    var workoutsOfDayId: String!
    
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
            // make button
            //        let barItem = UINavigationItem()
            //        barItem.title = "운동"
            
            //        let leftBarButton = UIBarButtonItem()
            //        leftBarButton.title = "취소"
            //        leftBarButton.tintColor = .tintColor
            //        leftBarButton.action = #selector(dismiss(_:))
            //        barItem.leftBarButtonItem = leftBarButton
            //        bar.items = [barItem]
        }
        
        
        // Delete bottom border of nav bar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        return bar
    }()
    
    weak var workoutAddButton: UIButton!
    
    weak var headerView: WorkoutAddHeaderView!
    
    weak var footerView: WorkoutAddFooterView!
    
    weak var tableView: UITableView!
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        configureTableView()
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
        guard let workout = tempWorkout else { return }
        headerView.partButton.partRawValue = workout.part
    }
}

// MARK: Setup functions

extension WorkoutAddViewController {
    
    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.backgroundColor = .white
        
        let headerView = WorkoutAddHeaderView()
        let footerView = WorkoutAddFooterView()
        footerView.frame.size.height = Size.Cell.footerHeight
        
        let tableView = UITableView()
        tableView.tableFooterView = footerView
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .interactive
        
        let workoutAddButton = UIButton()
        workoutAddButton.setBackgroundColor(.tintColor, for: .normal)
        workoutAddButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.7),
                                            for: .highlighted)
        workoutAddButton.setBackgroundColor(.lightGray, for: .disabled)
        workoutAddButton.setTitle("완료", for: .normal)
        workoutAddButton.titleLabel?.textAlignment = .center
        workoutAddButton.titleLabel?.font = .smallBoldTitle
        
        self.headerView = headerView
        self.footerView = footerView
        self.tableView = tableView
        self.workoutAddButton = workoutAddButton
        
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.workoutAddButton)
        
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
    
    private func configureTableView() {
        tableView.contentInset.top = Inset.scrollViewTopInset
        tableView.contentInset.bottom = Inset.scrollViewBottomInset
        tableView.rowHeight = Size.Cell.height
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorkoutSetTableViewCell.self)
    }
    
    private func setupModel() {
        if let workoutId = self.workoutId,
            let object = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: workoutId) {
            tempWorkout = object.copy() as? Workout
            headerView.nameTextField.text = tempWorkout?.name
        } else {
            let newWorkout = Workout()
            tempWorkout = newWorkout
        }
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
        textFieldDidEndEditing(self.headerView.nameTextField)
        guard let workout = self.tempWorkout else { return }
        if workout.name == "" {
            return
        }
        
        if self.workoutId == nil {
            // create new workout data
            let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self, forPrimaryKey: self.workoutsOfDayId)
            
            DBHandler.shared.write {
                workoutsOfDay?.workouts.append(workout)
            }
            
        } else {
            // ??????????????
            // ??????????????
            // ??????????????
            // ??????????????
            // ??????????????
            // ??????????????
            // ??????????????
            // update origin data
            guard let originWorkout = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: workoutId!) else { return }
            DBHandler.shared.write {
                originWorkout.copy(from: workout)
            }
        }
        self.postNotification(.WorkoutDidModifiedNotification)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func workoutSetDidAdded(_ sender: UIButton? = nil) {
        guard let workout = self.tempWorkout else { return }
        let newWorkoutSet = WorkoutSet()
        self.tempWorkout?.sets.append(newWorkoutSet)
        let targetIndexPath = IndexPath(row: workout.numberOfSets - 1, section: 0)
        self.tableView.insertRows(at: [targetIndexPath], with: .automatic)
        self.tableView.scrollToRow(at: targetIndexPath, at: .top, animated: true)
    }
    
    @objc func showActionSheet(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "파트 설정", message: nil, preferredStyle: .actionSheet)
        for part in Part.allCases {
            let action = makeAlertAction(for: part)
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func makeAlertAction(for part: Part) -> UIAlertAction {
        if part == .none {
            let alertAction = UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil)
            return alertAction
        } else {
            let alertAction = UIAlertAction(title: part.description,
                                            style: .default) { [weak self] _ in
                                                self?.setWorkoutPart(rawValue: part.rawValue)
            }
            return alertAction
        }
    }
    
    private func setWorkoutPart(rawValue part: Part.RawValue) {
        // MARK: 더 좋은 방법이 없을 까...?!
        tempWorkout?.part = part
        headerView.partButton.partRawValue = part
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
        return self.tempWorkout?.numberOfSets ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workout = self.tempWorkout else { fatalError() }
        let cell = tableView.dequeueReusableCell(WorkoutSetTableViewCell.self, for: indexPath)
        let workoutSet = workout.sets[indexPath.row]
        
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
                self.tempWorkout?.sets.remove(at: indexPath.row)
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

// MARK: TextField Delegate

extension WorkoutAddViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // have to write in Realm transaction
        DBHandler.shared.write {
            self.tempWorkout?.name = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // If there is no cells, add new cell automatically
        if self.tempWorkout?.numberOfSets == 0 {
            workoutSetDidAdded()
        }
        return true
    }
}
