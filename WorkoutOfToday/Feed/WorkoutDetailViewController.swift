//
//  WorkoutDetailViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/12.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: BasicViewController {
    
    // MARK: Model
    
    var workout: Workout?
    
    // MARK: View
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func configureNavigationBar() {
        let closeButton = CloseButton(target: self, action: #selector(dismiss(_:)))
        navigationBar.topItem?.title = workout?.name
        navigationBar.topItem?.rightBarButtonItem = closeButton
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerByNib(TodayWorkoutSectionHeaderView.self)
        tableView.registerByNib(CalendarTableViewCell.self)
        tableView.registerByNib(CalendarFooterView.self)
    }
}

// MARK: objc functions

extension WorkoutDetailViewController {
    @objc
    private func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: TableView Delegate

extension WorkoutDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let workout = workout else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(TodayWorkoutSectionHeaderView.self)
        headerView.tag = section
        headerView.workout = workout
        headerView.isDetailView = true
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        headerView.backgroundView = backgroundView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: Footer
    // Note that buttton.tag means section
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(CalendarFooterView.self)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        footerView.backgroundView = backgroundView
        
        return footerView
    }
}

// MARK: TableView DataSource

extension WorkoutDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workout = workout else { return 0 }
        return workout.numberOfSets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workout = workout else { return UITableViewCell() }
        let workoutSet = workout.sets[indexPath.row]
        let cell = tableView.dequeueReusableCell(CalendarTableViewCell.self, for: indexPath)
        cell.countLabel.text = "\(indexPath.row + 1)"
        cell.workoutSet = workoutSet
        return cell
    }
}
