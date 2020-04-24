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
    
    fileprivate weak var calendar: FSCalendar!
    
    fileprivate weak var calendarHeaderView: CalendarHeaderView!
    
    override func setup() {
        configureContainerTableView()
    }
    
    fileprivate func configureContainerTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.showsVerticalScrollIndicator = false
        
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
        tableView.register(UITableViewCell.self)
        
        view.insertSubview(tableView, at: 0)
        self.containerTableView = tableView
        
        self.containerTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
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
        containerTableView.reloadData()
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
}

// MARK: TableView Data Source

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutsOfSelectedDay?.numberOfWorkouts ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        let workout = self.workoutsOfSelectedDay?.workouts[indexPath.row]
        cell.textLabel?.text = workout?.name
        return cell
    }
}
