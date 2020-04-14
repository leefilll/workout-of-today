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
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchAllWorkoutsOfDay()
        self.configureCollectionView()
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

// MARK: CollectionView DataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.workoutsOfDays?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let workoutsOfDays = self.workoutsOfDays else { return 0 }
        let workoutsOfDay = workoutsOfDays[section]
        return workoutsOfDay.countOfWorkouts
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
        guard let workoutsOfDay = self.workoutsOfDays?[indexPath.section] else { fatalError() }

        let header = collectionView
            .dequeueReusableSupplementaryHeaderView(FeedCollectionReusableView.self,
                                                    for: indexPath)
        
        header.dateLabel.text = DateFormatter.sharedFormatter.dateString(from: workoutsOfDay.createdDateTime)
        return header
    }
}

// MARK: CollectionView Delegate
extension FeedViewController: UICollectionViewDelegate {
    
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
