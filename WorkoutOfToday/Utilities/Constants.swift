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
        static let height: CGFloat = 40
        static let footerHeight: CGFloat = 40
    }
    static let addButtonHeight: CGFloat = 50
    static let recentCollectionViewHeight: CGFloat = 50
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
    
    var color: UIColor {
        return UIColor.part(self)
    }
    
    var description: String {
        switch self {
            case .none: return "없음"
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
}

enum Equipment: Int, CustomStringConvertible, CaseIterable {
    case babel
    case dumbell
    case kettlebell
    case machine
    case other
    case none
    
    var description: String {
        switch self {
            case .none: return "없음"
            case .babel: return "바벨"
            case .dumbell: return "덤벨"
            case .kettlebell: return "케틀벨"
            case .machine: return "머신"
            case .other: return "기타"
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
