//
//  DateFormatter+String.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// Set date format to Korea
    static let sharedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .long
        formatter.timeStyle = .full
        return formatter
    }()
    
    func dateString(from date: Date) -> String {
        let fullDateString = DateFormatter.sharedFormatter.string(from: date)
        let rangeForDate = 0...2
        let dateArr = fullDateString.components(separatedBy: " ")[rangeForDate]
        let dateString = dateArr.joined(separator: " ")
        return dateString
    }
    
    func timeString(from date: Date) -> String {
        let fullTimeString = DateFormatter.sharedFormatter.string(from: date)
        let rangeForTime = 3...5
        let timeArr = fullTimeString.components(separatedBy: " ")[rangeForTime]
        let timeString = timeArr.joined(separator: " ")
        return timeString
    }
}

extension Date {
    static var now: Date {
        return Date()
    }
}
