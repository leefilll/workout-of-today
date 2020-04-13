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
}

enum Size {
    enum Cell {
        static let height: CGFloat = 50
        static let footerHeight: CGFloat = 60
    }
}

enum Part: Int, CustomStringConvertible, CaseIterable {
    case none = 0
    case chest
    case shoulder
    case back
    case legs
    case abdominal
    case arms
    case cardio
    

    var color: UIColor {
        return UIColor.partColor(self.rawValue)
    }
    
    var description: String {
        switch self {
            case .none: return "없음"
            case .chest: return "가슴"
            case .shoulder: return "어깨"
            case .back: return "등"
            case .legs: return "다리"
            case .abdominal: return "복근"
            case .arms: return "팔"
            case .cardio: return "유산소"
        }
    }
}
