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

class FeedMasterViewController: BaseViewController {
    
    // MARK: Model
    
    private let workoutsOfDays = DBHandler.shared.fetchObjects(ofType: WorkoutsOfDay.self)
    
    // MARK: View
    
    var segmentedControl: UISegmentedControl!
    
    var contentView: UIView!
    
    private lazy var dailyCollectionViewController: DailyCollectionViewController = {[weak self] in
        let dailyCollectionViewController = DailyCollectionViewController()
        self?.add(asChildViewController: dailyCollectionViewController)
        dailyCollectionViewController.workoutsOfDays = self?.workoutsOfDays
        return dailyCollectionViewController
        }()
    
    private lazy var calendarViewController: CalendarViewController = {[weak self] in
        let calendarViewController = CalendarViewController()
        self?.add(asChildViewController: calendarViewController)
        calendarViewController.workoutsOfDays = self?.workoutsOfDays
        return calendarViewController
        }()
    
    
    // MARK: View Life Cycle
    override func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        
        self.title = "이력"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.barTintColor = .groupTableViewBackground
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
        
        configureSegmentedControll()
        configureContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        //        configureCollectionView()
        //        addNotificationBlock()
        
        
        //        self.configureCollectionView()
        //        self.addNotificationBlock()
        //        self.addObserverToNotificationCenter(.WorkoutDidModifiedNotification, selector: #selector(reloadData(_:)))
        //        self.addObserverToNotificationCenter(.WorkoutDidAddedNotification,
        //                                             selector: #selector(fetchAllWorkoutsOfDays(_:)))
    }
    
    deinit {
        self.token?.invalidate()
    }
    
    
    private func configureSegmentedControll() {
        let items = ["일별", "월별", "차트", "프로필"]
        
        self.segmentedControl = UISegmentedControl(items: items)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.layer.cornerRadius = 5.0
        self.segmentedControl.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        self.segmentedControl.setBackgroundColor(.tintColor, for: .selected)
        self.segmentedControl.tintColor = .tintColor
        self.segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
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
        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
        }
    }
    
    private func configureContentView() {
        self.contentView = UIView()
        self.contentView.backgroundColor = .groupTableViewBackground
        self.view.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        contentView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
                remove(asChildViewController: calendarViewController)
                add(asChildViewController: dailyCollectionViewController)
                break
            case 1:
                remove(asChildViewController: dailyCollectionViewController)
                add(asChildViewController: calendarViewController)
                break
            case 2:
                break
            default:
                break
        }
//        if segmentedControl.selectedSegmentIndex == 0 {
//            add(asChildViewController: dailyCollectionViewController)
//        }
        //        if segmentedControl.selectedSegmentIndex == 0 {
        //            remove(asChildViewController: sessionsViewController)
        //            add(asChildViewController: summaryViewController)
        //        } else {
        //            remove(asChildViewController: summaryViewController)
        //            add(asChildViewController: sessionsViewController)
        //        }
    }
}

// MARK: objc functions

extension FeedMasterViewController {
    @objc func selectionDidChange(_ segmentedControl: UISegmentedControl) {
        updateView()
    }
}
