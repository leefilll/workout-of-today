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

class FeedMasterViewController: BasicViewController {
    
    // MARK: Model
    
    var workoutsOfDays: Results<WorkoutsOfDay>?
    
    override var navigationBarTitle: String {
        return "이력"
    }
    
    // MARK: View
    
    private var segmentedControl: UISegmentedControl!
    
    private var contentView: UIView!
    
//    private var dailyCollectionViewController: DailyCollectionViewController!
//
//    private var calendarViewController: CalendarViewController!
    
    // MARK: ===== for test ==========
    
    private weak var collectionView: UICollectionView!
    
    private func setupCollectionView() {
        let layout = FeedCollectionViewFlowLayout(minimumInteritemSpacing: 5, minimumLineSpacing: 8, sectionInset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset.bottom = 20
        collectionView.alwaysBounceVertical = true
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView = collectionView
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LabelCollectionViewCell.self)
        collectionView.registerForHeaderView(LabelCollectionHeaderView.self)
    }
    
    // MARK: ===== end test ==========

    // MARK: View Life Cycle
    override func setup() {
        setupSegmentedControll()
        setupContentView()
        setupCollectionView()
//        setupChildViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        updateView()
    }
//
//    override func registerNotifications() {
//        registerNotification(.WorkoutDidDeleted) { [weak self] note in
//            guard let collectionView = self?.collectionView else { return }
//            collectionView.reloadData()
//        }
//        registerNotification(.WorkoutDidAdded) { [weak self] note in
//            guard let collectionView = self?.collectionView else { return }
//            collectionView.reloadData()
//        }
//    }
//
    private func setupChildViews() {
//        dailyCollectionViewController = DailyCollectionViewController()
//        calendarViewController = CalendarViewController()
    }

    private func fetchData() {
        workoutsOfDays = DBHandler.shared.fetchObjects(ofType: WorkoutsOfDay.self)
//        dailyCollectionViewController.workoutsOfDays = workoutsOfDays
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.titleView = segmentedControl
    }
    
    private func setupSegmentedControll() {
        let items = ["일별", "월별"]
        
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = .weakTintColor
        segmentedControl.setBackgroundColor(.tintColor, for: .selected)
        segmentedControl.tintColor = .tintColor
        segmentedControl.addTarget(self, action: #selector(selectionDidChanged(_:)), for: .valueChanged)
        
        // TODO: change to all versions
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .tintColor
            segmentedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ],
                for: .selected
            )
            segmentedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.tintColor,
                    NSAttributedString.Key.font: UIFont.subheadline
                ],
                for: .normal
            )
        }
        segmentedControl.bounds.size.width = 150
    }
    
    private func setupContentView() {
        contentView = UIView()
        contentView.backgroundColor = .defaultBackgroundColor
        
        view.insertSubview(contentView, at: 0)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func add<T>(asChildViewController viewController: T) where T: Childable {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        contentView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        viewController.workoutsOfDays = workoutsOfDays
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                break;
//                remove(asChildViewController: calendarViewController)
//                add(asChildViewController: dailyCollectionViewController)
            case 1:
//                remove(asChildViewController: dailyCollectionViewController)
//                add(asChildViewController: calendarViewController)
                break;
            default:
                break
        }
    }
}

// MARK: objc functions

extension FeedMasterViewController {
    @objc func selectionDidChanged(_ segmentedControl: UISegmentedControl) {
        updateView()
    }
}

// MARK: Child VC protocol
protocol Childable where Self: BasicViewController {
//    var workoutsOfDays: Results<WorkoutsOfDay>? { get set }
}


// MARK: CollectionView DataSource

extension FeedMasterViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let workoutsOfDays = workoutsOfDays else { return 0 }
        return workoutsOfDays.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let workoutsOfDays = workoutsOfDays else { return 0}
        let workoutsOfDay = workoutsOfDays[section]
        return workoutsOfDay.numberOfWorkouts
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let workoutsOfDays = workoutsOfDays else { return UICollectionViewCell() }
        let workoutsOfDay = workoutsOfDays[indexPath.section]
        let workout = workoutsOfDay.workouts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(LabelCollectionViewCell.self, for: indexPath)
        cell.content = workout
        return cell
    }
    
    // MARK: Header View
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let workoutsOfDays = workoutsOfDays else { return UICollectionReusableView() }
        let header = collectionView
            .dequeueReusableSupplementaryView(LabelCollectionHeaderView.self, for: indexPath)
        let workoutsOfDay = workoutsOfDays[indexPath.section]
//        workoutsOfDay
        header.titleLabel.text = DateFormatter.shared.string(from: workoutsOfDay.createdDateTime)

        return header
    }
}

// MARK: CollectionView Delegate

extension FeedMasterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let workoutsOfDay = self.workoutsOfDays[indexPath.section]
//        let workout = workoutsOfDay.workouts[indexPath.item]
//        let vc = WorkoutAddViewController()
//        vc.tempWorkout = workout
        //        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate Flow Layout

extension FeedMasterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let workoutsOfDays = workoutsOfDays else { return .zero }
        let workoutsOfDay = workoutsOfDays[indexPath.section]
        let workout = workoutsOfDay.workouts[indexPath.item]
        let workoutName = workout.name
        let fontAtttribute = [NSAttributedString.Key.font: UIFont.smallBoldTitle]
        let size = workoutName.size(withAttributes: fontAtttribute)

        let extraSpace: CGFloat = 22
        let width = size.width + extraSpace

        let insetHorizontal: CGFloat = 30
        let maximumWidth = collectionView.bounds.width - insetHorizontal

        if width > maximumWidth {
            return CGSize(width: maximumWidth, height: 40)
        }
        return CGSize(width: width, height: 40)
    }
}



