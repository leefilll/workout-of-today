//
//  CalendarView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/18.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import FSCalendar

class CalendarView: BaseView {

    @IBOutlet weak var calendar: FSCalendar!
    
    override func setup() {
        calendar.delegate = self
        calendar.dataSource = self
    }
}

// MARK: Calendar Delegate

extension CalendarView: FSCalendarDelegate {
    
}

// MARK: Calendar Data Source

extension CalendarView: FSCalendarDataSource {
    
}
