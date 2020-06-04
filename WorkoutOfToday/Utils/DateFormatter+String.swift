//
//  DateFormatter+String.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    // MARK: Global formatter
    static var shared: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("MMMM-dEEEE")
        return formatter
    }
    
    // MARK:  Set date format to Korea for testing
    static let korean: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .long
        formatter.timeStyle = .full
        return formatter
    }()
    
//    var keyStringFromNow: String {
//        let now = Date.now
//        let year = self.string(of: .year, from: now)
//        let month = self.string(of: .month, from: now)
//        let day = self.string(of: .day, from: now)
//
//        return year + "-" + month + "-" + day
//    }
    
//    func keyStringFromDate(_ date: Date) -> String {
//        let year = self.string(of: .year, from: date)
//        let month = self.string(of: .month, from: date)
//        let day = self.string(of: .day, from: date)
//
//        return year + "-" + month + "-" + day
//    }
    
    func string(of component: Calendar.Component, from date: Date) -> String {
        let calendar = Calendar.current
        return "\(calendar.component(component, from: date))"
    }
    
    func string(from date: Date, type: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate(type)
        return formatter.string(from: date)
    }
}

extension Date {
    static var now: Date {
        return Date()
    }
}
