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

class CalendarViewController: BaseViewController {
    
    // MARK: Model
    
    var workoutsOfDays: Results<WorkoutsOfDay>!
    
    // MARK: View
    
    fileprivate weak var tableView: UITableView!
    
    fileprivate weak var calendar: FSCalendar!
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func setup() {
        configureCalendar()
        configureTableView()
    }
    
    private func configureCalendar() {
        let calendar = FSCalendar()
        calendar.backgroundColor = .white
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 10
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.appearance.headerTitleFont = .smallBoldTitle
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.appearance.todayColor = UIColor.tintColor.withAlphaComponent(0.1)
        calendar.appearance.titleTodayColor = .tintColor
        calendar.appearance.weekdayFont = .boldBody
        calendar.appearance.titleFont = .body
        calendar.appearance.selectionColor = .tintColor
        calendar.appearance.eventDefaultColor = .tintColor
//        calendar.appearance.e
        
        self.calendar = calendar
        
        view.addSubview(self.calendar)
        view.addGestureRecognizer(scopeGesture)
        self.calendar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.height.equalTo(300)
        }
    }
    
    private func configureTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        
        self.tableView = tableView
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.calendar.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: Calendar Delegate

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.calendar.setScope(.week, animated: true)
    }
    
    
}

// MARK: Calendar Data Source

extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        print(#function)
        print(date)
        
        return 0
//
//        let dateString = self.dateFormatter2.string(from: date)
//        if self.datesWithEvent.contains(dateString) {
//            return 1
//        }
//        if self.datesWithMultipleEvents.contains(dateString) {
//            return 3
//        }
//        return 0
    }
    
}

// MARK: Gesture Recognizer Delegate

extension CalendarViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
                case .month:
                    return velocity.y < 0
                case .week:
                    return velocity.y > 0
                @unknown default:
                    fatalError()
            }
        }
        return shouldBegin
    }
}

// MARK: TableView Delegate

extension CalendarViewController: UITableViewDelegate {
    
}

// MARK: TableView Data Source

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        //        let workoutsOfDay = self.workoutsOfDays.filter(<#T##predicate: NSPredicate##NSPredicate#>)
        cell.textLabel?.text = "Test"
        return cell
    }
}
