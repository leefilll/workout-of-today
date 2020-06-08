//
//  Constants.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/09.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

enum Inset {
    enum Cell {
        static let horizontalInset = 20
        static let veticalInset = 13
    }
    
    static let workoutCellHorizontalInset = Inset.Cell.horizontalInset
    static let workoutCellVerticalInset = 7
    static let paddingHorizontal = 15
    static let paddingVertical = 10
    
    static let scrollViewTopInset: CGFloat = 10
    static let scrollViewBottomInset: CGFloat = 20
}

enum Size {
    enum Cell {
        static let rowHeight: CGFloat = 40
        static let headerHeight: CGFloat = 65
        static let footerHeight: CGFloat = 70
    }
    static let cornerRadius: CGFloat = 9
    static let addButtonHeight: CGFloat = 50
    static let addCollectionViewHeight: CGFloat = 50
}

enum Part: Int, CustomStringConvertible, CaseIterable {
    case chest
    case shoulder
    case back
    case legs
    case core
    case arms
    case cardio
    case body
    case none
    
    static let title: String = {
        return "운동 파트"
    }()
    
    var color: UIColor {
        return UIColor.part(self)
    }
    
    var description: String {
        switch self {
            case .none: return "-"
            case .chest: return "가슴"
            case .shoulder: return "어깨"
            case .back: return "등"
            case .legs: return "다리"
            case .core: return "코어"
            case .arms: return "팔"
            case .cardio: return "유산소"
            case .body: return "전신"
        }
    }
    
    static func string(from rawValue: Int) -> String? {
        return Part(rawValue: rawValue)?.description
    }
}

enum Equipment: Int, CustomStringConvertible, CaseIterable {
    case babel
    case dumbell
    case kettlebell
    case machine
    case other
    case none
    
    static let title: String = {
        return "도구"
    }()
    
    var color: UIColor {
        if self == .none { return .lightGray }
        return .tintColor
    }
    
    var description: String {
        switch self {
            case .babel: return "바벨"
            case .dumbell: return "덤벨"
            case .kettlebell: return "케틀벨"
            case .machine: return "머신"
            case .other: return "기타"
            case .none: return "-"
        }
    }
}

enum Style: Int, CustomStringConvertible, CaseIterable {
    case weightWithReps
    case weight
    case reps
    case time
    case none
    
    static let title: String = {
        return "스타일"
    }()
    
    var description: String {
        switch self {
            case .weightWithReps: return "무게 + 횟수"
            case .weight: return "무게"
            case .reps: return "횟수"
            case .time: return "시간"
            case .none: return "-"
        }
    }
}

enum Degree: Int {
    case fail
    case hard
    case medium
    case easy
    case none
}


protocol Selectable {}

extension Selectable {
    var title: String {
        if self is Part {
            return Part.title
        } else if self is Style {
            return Style.title
        } else {
            return ""
        }
    }
    
    var name: String {
        switch self {
            case let part as Part:
                return part.description
            case let style as Style:
                return style.description
            case let workout as Workout:
                return workout.name
            case let template as WorkoutTemplate:
                return template.name
            default:
                return ""
        }
    }
}

extension Part: Selectable {}

extension Style: Selectable {}

extension Workout: Selectable {}

extension WorkoutTemplate: Selectable {}
