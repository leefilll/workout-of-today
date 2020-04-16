//
//  FeedViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class FeedViewController: UIViewController {
    
    // MARK: Model
    
    private let realm = try! Realm()
    
    private var workoutsOfDays: Results<WorkoutsOfDay>?
    
    // MARK: View
    
    var collectionView: UICollectionView!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.configureCollectionView()
//        self.addObserverToNotificationCenter(.WorkoutDidAddedNotification,
//                                             selector: #selector(fetchAllWorkoutsOfDays(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchAllWorkoutsOfDays()
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
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.collectionView.backgroundColor = .white
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
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
    
    private func fetchAllWorkoutsOfDay() {
        self.workoutsOfDays = realm.objects(WorkoutsOfDay.self)
    }
}

// MARK: objc functions

extension FeedViewController {
    @objc func fetchAllWorkoutsOfDays(_ notification: Notification? = nil) {
        self.workoutsOfDays = realm.objects(WorkoutsOfDay.self)
        self.collectionView.reloadData()
//         guard let workoutsOfToday = self.workoutsOfToday else { return }
//         if let workoutPrimaryKey = notification.userInfo?["PrimaryKey"] as? String,
//             let addedWorkout = self.realm.object(ofType: Workout.self,
//                                                  forPrimaryKey: workoutPrimaryKey){
//             if !workoutsOfToday.workouts.contains(addedWorkout) {
//                 self.realm.writeToRealm {
//                     workoutsOfToday.workouts.append(addedWorkout)
//                 }
//             } else {
//                 // already exist
//
//             }
//
//             self.tableView.reloadData()
//             let countOfWorkouts = workoutsOfToday.countOfWorkouts
//             let targetIndexPath = IndexPath(row: countOfWorkouts - 1, section: 0)
//             self.tableView.scrollToRow(at: targetIndexPath, at: .middle, animated: true)
//         }
     }
}

// MARK: CollectionView DataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.workoutsOfDays?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let workoutsOfDays = self.workoutsOfDays else { return 0 }
        let workoutsOfDay = workoutsOfDays[section]
        return workoutsOfDay.numberOfWorkouts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let workoutsOfDay = self.workoutsOfDays?[indexPath.section] else {
            fatalError()
        }
        let cell = collectionView.dequeueReusableCell(FeedCollectionViewCell.self,
                                                      for: indexPath)
        
        let workout = workoutsOfDay.workouts[indexPath.item]
        cell.workout = workout
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView
            .dequeueReusableSupplementaryHeaderView(FeedCollectionReusableView.self,
                                                    for: indexPath)
        
//        header.dateLabel.text = DateFormatter.shared.dateString(from: workoutsOfDay.createdDateTime)
        return header
    }
}

// MARK: CollectionView Delegate
extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let workoutsOfDay = self.workoutsOfDays?[indexPath.section] else { return }
        let workout = workoutsOfDay.workouts[indexPath.item]
        let vc = WorkoutAddViewController()
        vc.workout = workout
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: CollectionView Delegate Flow Layout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let workoutsOfDay = self.workoutsOfDays?[indexPath.section] else { return CGSize(width: 0, height: 0) }
        
        let workout = workoutsOfDay.workouts[indexPath.item]
        let workoutName = workout.name
        let itemSize = workoutName.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldTitle
        ])

        return CGSize(width: itemSize.width + 25, height: 40)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width
            , height: 80)
    }
}
