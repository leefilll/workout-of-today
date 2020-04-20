//
//  DateFormatter+String.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    var keyStringFromDate: String {
        let now = Date.now
        let year = self.string(of: .year, from: now)
        let month = self.string(of: .month, from: now)
        let day = self.string(of: .day, from: now)
        
        return year + "-" + month + "-" + day
    }
    
    // MARK: Global formatter
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("MMMM-dEEEE")
        return formatter
    }()
    
    // MARK:  Set date format to Korea for testing
    static let korean: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .long
        formatter.timeStyle = .full
        return formatter
    }()
    
    func string(of component: Calendar.Component, from date: Date) -> String {
        let calendar = Calendar.current
        return "\(calendar.component(component, from: date))"
    }
        
//    func dateString(from date: Date) -> String {
//        let fullDateString = DateFormatter.shared.string(from: date)
//        let rangeForDate = 0...2
//        let dateArr = fullDateString.components(separatedBy: " ")[rangeForDate]
//        let dateString = dateArr.joined(separator: " ")
//        return dateString
//    }
//
//    func timeString(from date: Date) -> String {
//        let fullTimeString = DateFormatter.shared.string(from: date)
//        let rangeForTime = 3...5
//        let timeArr = fullTimeString.components(separatedBy: " ")[rangeForTime]
//        let timeString = timeArr.joined(separator: " ")
//        return timeString
//    }
}

extension Date {
    static var now: Date {
        return Date()
    }
}
