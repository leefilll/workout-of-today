//
//  CalendarHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import FSCalendar

class CalendarHeaderView: BasicView {
    
    weak var calendar: FSCalendar!
    
    weak var toggleCalendarButton: BasicButton!

    override func setup() {
        backgroundColor = .clear
        
        setupCalendar()
        setupButton()
    }
    
    private func setupCalendar() {
        let calendar = FSCalendar()
        calendar.backgroundColor = .white
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 10
        
        calendar.appearance.headerTitleFont = .smallBoldTitle
        calendar.appearance.headerTitleColor = .tintColor
        calendar.appearance.weekdayTextColor = .tintColor
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.appearance.todayColor = UIColor.tintColor.withAlphaComponent(0.1)
        calendar.appearance.titleTodayColor = .tintColor
        calendar.appearance.weekdayFont = .boldBody
        calendar.appearance.titleFont = .body
        calendar.appearance.selectionColor = .tintColor
        calendar.appearance.eventDefaultColor = .tintColor
        calendar.appearance.todayColor = nil
        calendar.appearance.eventOffset = CGPoint(x: 0, y: 0)
        
        addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-15)
        }

        self.calendar = calendar
    }
    
    private func setupButton() {
        let button = BasicButton()
        
        button.setTitle("접기", for: .normal)
        button.setTitle("열기", for: .selected)
        
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.tintColor, for: .selected)
        
        button.setBackgroundColor(.concaveColor, for: .normal)
        button.setBackgroundColor(.weakTintColor, for: .selected)
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.width.equalTo(50)
            make.height.equalTo(23)
            make.bottom.equalTo(calendar.snp.top).offset(-5)
        }
        self.toggleCalendarButton = button
    }
}
