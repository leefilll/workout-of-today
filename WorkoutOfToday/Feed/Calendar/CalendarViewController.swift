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
import DZNEmptyDataSet

class CalendarViewController: BasicViewController, Childable {
    
    // MARK: Model
    
    var sections: [(Date, Results<Workout>)]!
    
    var workoutsInSelectedDay: Results<Workout>? {
        didSet {
            containerTableView.reloadData()
        }
    }
    
    // MARK: View
    
    private weak var containerTableView: UITableView!
    
    private weak var calendarHeaderView: CalendarHeaderView!
    
    override func setup() {
        configureContainerTableView()
    }
    
    override func registerNotifications() {
        registerNotification(.WorkoutDidAdded) { [weak self] note in
            self?.containerTableView.reloadData()
        }
        
        registerNotification(.WorkoutDidDeleted) { [weak self] note in
            self?.containerTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureContainerTableView() {
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
    func toggleButtonDidTapped(_ sender: BasicButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            calendarHeaderView.calendar.setScope(.month, animated: true)
        } else {
            calendarHeaderView.calendar.setScope(.week, animated: true)
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
        calendarHeaderView.toggleCalendarButton.isSelected = false
        calendar.setScope(.week, animated: true)
        
        // MARK: update model workoutsInSelectedDay
        let startDate = Calendar.current.startOfDay(for: date)
        guard let section = sections
            .filter({ $0.0 == startDate })
            .first else {
                workoutsInSelectedDay = nil
                return
        }
        workoutsInSelectedDay = section.1
    }
}

// MARK: Calendar Data Source

extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let startDate = Calendar.current.startOfDay(for: date)
        let section = sections.filter({ $0.0 == startDate })
        if section.isEmpty {
            return 0
        }
        return 1
    }
}

// MARK: TableView Delegate

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let workoutsInSelectedDay = workoutsInSelectedDay else { return nil }
        let workout = workoutsInSelectedDay[section]
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
        guard let workoutsInSelectedDay = workoutsInSelectedDay else { return 0}
        return workoutsInSelectedDay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workoutsInSelectedDay = workoutsInSelectedDay else { return 0}
        let workout = workoutsInSelectedDay[section]
        return workout.sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workoutsInSelectedDay = workoutsInSelectedDay else { return UITableViewCell() }
        let workout = workoutsInSelectedDay[indexPath.section]
        let workoutSet = workout.sets[indexPath.row]
        let cell = tableView.dequeueReusableCell(CalendarTableViewCell.self, for: indexPath)
        cell.countLabel.text = "\(indexPath.row + 1)"
        cell.workoutSet = workoutSet
        return cell
    }
}

// MARK: DZNEmptyDataSet DataSource and Delegate

extension CalendarViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "기록된 운동이 없습니다."
        let font = UIFont.smallBoldTitle
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return containerTableView.tableHeaderView!.frame.height - 200
    }
}

