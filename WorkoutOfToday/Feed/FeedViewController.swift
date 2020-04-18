//
//  FeedViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit
import RealmSwift

class FeedViewController: UIViewController {
    
    // MARK: Model
    
    private var token: NotificationToken? = nil
    
    private let workoutsOfDays = DBHandler.shared.fetchObjects(ofType: WorkoutsOfDay.self)
    
    // MARK: View
    
    var collectionView: UICollectionView!
    
    var segmentedControl: UISegmentedControl!
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        //        self.addNotificationBlock()
        self.addObserverToNotificationCenter(.WorkoutDidModifiedNotification, selector: #selector(reloadData(_:)))
        //        self.addObserverToNotificationCenter(.WorkoutDidAddedNotification,
        //                                             selector: #selector(fetchAllWorkoutsOfDays(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.fetchAllWorkoutsOfDay()
    }
    
    deinit {
        self.token?.invalidate()
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        
        self.title = "이력"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.barTintColor = .white
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
        
        let layout = FeedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0,
                                            height: 80)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .white
        self.collectionView.contentInset.bottom = 20
        
        let items = ["일별", "월별", "차트"]
        self.segmentedControl = UISegmentedControl(items: items)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.layer.cornerRadius = 5.0
        self.segmentedControl.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        self.segmentedControl.setBackgroundColor(.tintColor, for: .selected)
        self.segmentedControl.tintColor = .tintColor
        self.segmentedControl.addTarget(self, action: #selector(segmentedControl(_:)), for: .touchDown)
        
        // TODO: change to all versions
        if #available(iOS 13.0, *) {
            self.segmentedControl.selectedSegmentTintColor = .tintColor
            self.segmentedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ],
                for: .selected
            )
            self.segmentedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.tintColor,
                    NSAttributedString.Key.font: UIFont.subheadline
                ],
                for: .normal
            )
        }
        
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.collectionView)
        
        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
        }
        self.collectionView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.top.equalTo(self.segmentedControl.snp.bottom)
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(FeedCollectionViewCell.self)
        self.collectionView.registerForHeaderView(FeedCollectionReusableView.self)
    }
    
    private func addNotificationBlock() {
        self.token = self.workoutsOfDays.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
                case .initial, .update:
                    collectionView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
            }
        }
    }
}

// MARK: objc functions

extension FeedViewController {
    @objc func reloadData(_ sender: Notification) {
        self.collectionView.reloadData()
    }
    
    @objc func segmentedControl(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                // day - collectionView
                break
            case 1:
                // month - calendar
                break
            case 2:
                // charts
                break
            default:
                break
            
        }
    }
    //
    //    @objc func fetchAllWorkoutsOfDays(_ notification: Notification? = nil) {
    //        self.workoutsOfDays = realm.objects(WorkoutsOfDay.self)
    //        self.collectionView.reloadData()
    ////         guard let workoutsOfToday = self.workoutsOfToday else { return }
    ////         if let workoutPrimaryKey = notification.userInfo?["PrimaryKey"] as? String,
    ////             let addedWorkout = self.realm.object(ofType: Workout.self,
    ////                                                  forPrimaryKey: workoutPrimaryKey){
    ////             if !workoutsOfToday.workouts.contains(addedWorkout) {
    ////                 self.realm.writeToRealm {
    ////                     workoutsOfToday.workouts.append(addedWorkout)
    ////                 }
    ////             } else {
    ////                 // already exist
    ////
    ////             }
    ////
    ////             self.tableView.reloadData()
    ////             let countOfWorkouts = workoutsOfToday.countOfWorkouts
    ////             let targetIndexPath = IndexPath(row: countOfWorkouts - 1, section: 0)
    ////             self.tableView.scrollToRow(at: targetIndexPath, at: .middle, animated: true)
    ////         }
    //     }
}

// MARK: CollectionView DataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.workoutsOfDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let workoutsOfDay = self.workoutsOfDays[section]
        return workoutsOfDay.numberOfWorkouts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FeedCollectionViewCell.self, for: indexPath)
        let workoutsOfDay = self.workoutsOfDays[indexPath.section]
        let workout = workoutsOfDay.workouts[indexPath.item]
        cell.workout = workout
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView
            .dequeueReusableSupplementaryHeaderView(FeedCollectionReusableView.self, for: indexPath)
        let workoutsOfDay = self.workoutsOfDays[indexPath.section]
        header.dateLabel.text = DateFormatter.shared.string(from: workoutsOfDay.createdDateTime)
        
        return header
    }
}

// MARK: CollectionView Delegate

extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workoutsOfDay = self.workoutsOfDays[indexPath.section]
        let workout = workoutsOfDay.workouts[indexPath.item]
        let vc = WorkoutAddViewController()
        vc.tempWorkout = workout
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate Flow Layout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let workoutsOfDay = self.workoutsOfDays[indexPath.section]
        let workout = workoutsOfDay.workouts[indexPath.item]
        let workoutName = workout.name
        let fontAtttribute = [NSAttributedString.Key.font: UIFont.smallBoldTitle]
        let size = workoutName.size(withAttributes: fontAtttribute)
        
        let extraSpace: CGFloat = 22
        let width = size.width + extraSpace
        
        let insetHorizontal: CGFloat = 30
        let maximumWidth = self.collectionView.bounds.width - insetHorizontal
        
        if width > maximumWidth {
            return CGSize(width: maximumWidth, height: 40)
        }
        return CGSize(width: width, height: 40)
    }
}
