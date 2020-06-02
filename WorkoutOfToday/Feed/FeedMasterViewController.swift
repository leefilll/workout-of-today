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
    
    private var workoutsOfDays: Results<WorkoutsOfDay>? {
        didSet {
            dailyCollectionViewController.workoutsOfDays = workoutsOfDays
            calendarViewController.workoutsOfDays = workoutsOfDays
        }
    }

    
    override var navigationBarTitle: String {
        return "이력"
    }
    
    // MARK: View
    
    private var segmentedControl: UISegmentedControl!
    
    private var contentView: UIView!
    
    private var dailyCollectionViewController: DailyCollectionViewController!

    private var calendarViewController: CalendarViewController!

    
    // MARK: View Life Cycle
    override func setup() {
        setupChildViews()
        configureSegmentedControll()
        configureContentView()
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func setupChildViews() {
        dailyCollectionViewController = DailyCollectionViewController()
        calendarViewController = CalendarViewController()
    }
    
    private func fetchData() {
        workoutsOfDays = DBHandler.shared.fetchObjects(ofType: WorkoutsOfDay.self)
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.titleView = segmentedControl
    }
    
    override func registerNotifications() {
        registerNotification(.WorkoutDidDeleted) { [weak self] note in
            guard let strongSelf = self else { return }
            strongSelf.fetchData()
        }
        
        registerNotification(.WorkoutDidAdded) { [weak self] note in
            guard let strongSelf = self else { return }
            strongSelf.fetchData()
        }
    }
    
    private func configureSegmentedControll() {
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
    
    private func configureContentView() {
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
        viewController.workoutsOfDays = workoutsOfDays
        
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
            case 1:
                remove(asChildViewController: dailyCollectionViewController)
                add(asChildViewController: calendarViewController)
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
    var workoutsOfDays: Results<WorkoutsOfDay>? { get set }
}


