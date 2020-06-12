//
//  FeedCollectionView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/19.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import DZNEmptyDataSet

class DailyCollectionViewController: BasicViewController, Childable {
    
    // MARK: Model

    var sections: [(Date, Results<Workout>)]!
    
    lazy private var popupTransitioningDelegate = PopupTransitioningDelegate(height: self.view.bounds.height * 3 / 4)

    // MARK: View

    weak var collectionView: UICollectionView!

    override func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let layout = FeedCollectionViewFlowLayout(minimumInteritemSpacing: 3, minimumLineSpacing: 0, sectionInset: sectionInset)
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
    
    override func setupFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.register(LabelCollectionViewCell.self)
        collectionView.registerForHeaderView(LabelCollectionHeaderView.self)
    }

    override func registerNotifications() {
        registerNotification(.WorkoutDidAdded) { [weak self] note in
            self?.collectionView.reloadData()
        }
        
        registerNotification(.WorkoutDidDeleted) { [weak self] note in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: CollectionView DataSource

extension DailyCollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let workouts = sections[section].1
        return workouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let workouts = sections[indexPath.section].1
        let workout = workouts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(LabelCollectionViewCell.self, for: indexPath)
        cell.content = workout
        return cell
    }

    // MARK: Header View

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView
            .dequeueReusableSupplementaryView(LabelCollectionHeaderView.self, for: indexPath)
        let date = sections[indexPath.section].0
        header.titleLabel.text = DateFormatter.shared.string(from: date)
        return header
    }
}

// MARK: CollectionView Delegate

extension DailyCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workouts = sections[indexPath.section].1
        let workout = workouts[indexPath.row]
        
        let detailVC = WorkoutDetailViewController(nibName: "WorkoutDetailViewController", bundle: nil)
        detailVC.transitioningDelegate = popupTransitioningDelegate
        detailVC.modalPresentationStyle = .custom
        detailVC.workout = workout
        selectionFeedbackGenerator?.selectionChanged()
        present(detailVC, animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate Flow Layout

extension DailyCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let workouts = sections[indexPath.section].1
        let workout = workouts[indexPath.item]
        let workoutName = workout.name
        let fontAtttribute = [NSAttributedString.Key.font: UIFont.smallBoldTitle]
        let size = workoutName.size(withAttributes: fontAtttribute)

        let extraSpace: CGFloat = 30
        let width = size.width + extraSpace

        let insetHorizontal = collectionView.contentInset.left + collectionView.contentInset.right
        let maximumWidth = collectionView.bounds.width - insetHorizontal

        if width > maximumWidth {
            return CGSize(width: maximumWidth, height: 45)
        }
        return CGSize(width: width, height: 45)
    }
}

// MARK: DZNEmptyDataSet DataSource and Delegate

extension DailyCollectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "아직 등록된 운동이 없습니다."
        let font = UIFont.smallBoldTitle
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
}
