//
//  FeedCollectionView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/19.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class DailyCollectionViewController: BasicViewController, Childable {
    
    // MARK: Model
    
    var workoutsOfDays: Results<WorkoutsOfDay>? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: View
    
    private weak var collectionView: UICollectionView!
    
    override func setup() {
        let layout = FeedCollectionViewFlowLayout(minimumInteritemSpacing: 5, minimumLineSpacing: 8, sectionInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.bottom = 20
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LabelCollectionViewCell.self)
        collectionView.registerForHeaderView(LabelCollectionHeaderView.self)
    }
    
//    private func addNotificationBlock() {
//        guard let workoutsOfDays = self.workoutsOfDays else { return }
//        self.token = workoutsOfDays.observe { [weak self] (changes: RealmCollectionChange) in
//            guard let collectionView = self?.collectionView else { return }
//            switch changes {
//                case .initial, .update:
//                    collectionView.reloadData()
//                case .error(let error):
//                    fatalError("\(error)")
//            }
//        }
//    }
}

// MARK: CollectionView DataSource

extension DailyCollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.workoutsOfDays?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let workoutsOfDay = self.workoutsOfDays?[section]
        return workoutsOfDay?.numberOfWorkouts ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(LabelCollectionViewCell.self, for: indexPath)
        let workoutsOfDay = self.workoutsOfDays?[indexPath.section]
        let workout = workoutsOfDay?.workouts[indexPath.item]
        cell.content = workout
        return cell
    }
    
    // MARK: Header View
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let workoutsOfDays = workoutsOfDays else { return UICollectionReusableView() }
        let header = collectionView
            .dequeueReusableSupplementaryView(LabelCollectionHeaderView.self, for: indexPath)
        let workoutsOfDay = workoutsOfDays[indexPath.section]
        header.titleLabel.text = DateFormatter.shared.string(from: workoutsOfDay.createdDateTime)

        return header
    }
}

// MARK: CollectionView Delegate

extension DailyCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let workoutsOfDay = self.workoutsOfDays[indexPath.section]
//        let workout = workoutsOfDay.workouts[indexPath.item]
//        let vc = WorkoutAddViewController()
//        vc.tempWorkout = workout
        //        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate Flow Layout

extension DailyCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let workoutsOfDay = self.workoutsOfDays?[indexPath.section] else { return .zero }
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

