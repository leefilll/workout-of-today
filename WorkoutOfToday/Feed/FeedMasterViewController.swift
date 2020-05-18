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
    
    private let workoutsOfDays = DBHandler.shared.fetchObjects(ofType: WorkoutsOfDay.self)
    
    override var navigationBarTitle: String {
        return "이력"
    }
    
    // MARK: View
    
    var segmentedControl: UISegmentedControl!
    
    var contentView: UIView!
    
    private lazy var dailyCollectionViewController: DailyCollectionViewController = {[weak self] in
        let dailyCollectionViewController = DailyCollectionViewController()
        self?.add(asChildViewController: dailyCollectionViewController)
        return dailyCollectionViewController
        }()

    private lazy var calendarViewController: CalendarViewController = {[weak self] in
        let calendarViewController = CalendarViewController()
        self?.add(asChildViewController: calendarViewController)
        return calendarViewController
        }()

    private lazy var chartsViewController: ChartsViewController = {[weak self] in
        let chartsViewController = ChartsViewController(nibName: "ChartsViewController", bundle: nil)
        self?.add(asChildViewController: chartsViewController)
        return chartsViewController
        }()
    
    // MARK: View Life Cycle
    override func setup() {
        configureSegmentedControll()
        configureContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    deinit {
        self.token?.invalidate()
        print(String(describing: self) + " " + #function)
    }
    
    private func configureSegmentedControll() {
        let items = ["일별", "월별", "차트"]
        
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
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func configureContentView() {
        contentView = UIView()
        contentView.backgroundColor = .defaultBackgroundColor
        
        view.insertSubview(contentView, at: 0)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(segmentedControl.snp.top)
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
                remove(asChildViewController: chartsViewController)
                add(asChildViewController: dailyCollectionViewController)
                break

            case 1:
                remove(asChildViewController: dailyCollectionViewController)
                remove(asChildViewController: chartsViewController)
                add(asChildViewController: calendarViewController)
                break
            case 2:
                remove(asChildViewController: calendarViewController)
                remove(asChildViewController: dailyCollectionViewController)
                add(asChildViewController: chartsViewController)
                break
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
    var workoutsOfDays: Results<WorkoutsOfDay>! { get set }
}


