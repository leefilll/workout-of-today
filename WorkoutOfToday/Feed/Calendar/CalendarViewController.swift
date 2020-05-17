//
//  CalendarView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/18.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import FSCalendar

class CalendarViewController: BaseViewController, Childable {
    
    // MARK: Model
    
    var workoutsOfDays: Results<WorkoutsOfDay>!
    
    var workoutsOfSelectedDay: WorkoutsOfDay? {
        didSet {
            self.containerTableView.reloadData()
        }
    }
    
    // MARK: View
    
    fileprivate weak var containerTableView: UITableView!
    
    fileprivate weak var calendarHeaderView: CalendarHeaderView!
    
    override func setup() {
        configureContainerTableView()
    }
    
    fileprivate func configureContainerTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = true
        tableView.sectionHeaderHeight = Size.Cell.headerHeight
        tableView.sectionFooterHeight = 30
        tableView.rowHeight = Size.Cell.rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        let calendarHeaderView = CalendarHeaderView()
        calendarHeaderView.frame.size.height = 360
        calendarHeaderView.calendar.delegate = self
        calendarHeaderView.calendar.dataSource = self
        calendarHeaderView.toggleCalendarButton.addTarget(self,
                                                          action: #selector(toggleButtonDidTapped(_:)),
                                                          for: .touchUpInside)
        tableView.tableHeaderView = calendarHeaderView
        
        self.calendarHeaderView = calendarHeaderView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerByNib(CalendarTableViewCell.self)
        tableView.registerByNib(TodayWorkoutSectionHeaderView.self)
        tableView.registerByNib(CalendarFooterView.self)
        
        view.insertSubview(tableView, at: 0)
        self.containerTableView = tableView
        
        self.containerTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: objc functions

extension CalendarViewController {
    @objc
    func toggleButtonDidTapped(_ sender: BaseButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            calendarHeaderView.calendar.setScope(.week, animated: true)
        } else {
            calendarHeaderView.calendar.setScope(.month, animated: true)
        }
    }
}

// MARK: Calendar Delegate

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        let extraSize: CGFloat = 50
        calendarHeaderView.frame.size.height = bounds.height + extraSize
        view.layoutIfNeeded()
        
        containerTableView.beginUpdates()
        containerTableView.endUpdates()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // MARK: toggle calendar
        
        calendarHeaderView.toggleCalendarButton.isSelected = true
        calendar.setScope(.week, animated: true)
        
        // MARK: update model workoutsOfSelectedDay
        
        let keyStringFromDate = DateFormatter.shared.keyStringFromDate(date)
        let workoutsOfSelectedDay = workoutsOfDays.filter("id = %@", keyStringFromDate).first
        self.workoutsOfSelectedDay = workoutsOfSelectedDay
    }
}

// MARK: Calendar Data Source

extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let keyStringFromDate = DateFormatter.shared.keyStringFromDate(date)
        
        if let _ = workoutsOfDays.filter("id = %@", keyStringFromDate).first {
            return 1
        }
        return 0
    }
}

// MARK: TableView Delegate

extension CalendarViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let workout = workoutsOfSelectedDay?.workouts[section] else { return nil }

        let headerView = tableView.dequeueReusableHeaderFooterView(TodayWorkoutSectionHeaderView.self)
        headerView.tag = section
        headerView.workout = workout

        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        headerView.backgroundView = backgroundView

        return headerView
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

// MARK: TableView Data Source

extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfWorkouts = workoutsOfSelectedDay?.numberOfWorkouts else { return 0 }
        return numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workout = workoutsOfSelectedDay?.workouts[section] else { return 0 }
        return workout.numberOfSets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CalendarTableViewCell.self, for: indexPath)
        let workout = workoutsOfSelectedDay?.workouts[indexPath.section]
        let workoutSet = workout?.sets[indexPath.row]
        cell.countLabel.text = "\(indexPath.row + 1)"
        cell.workoutSet = workoutSet
        
        return cell
    }
}
