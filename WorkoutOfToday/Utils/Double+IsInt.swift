//
//  Double+IsInt.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/01.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

extension Double {
    var isInt: Bool {
        if floor(self) == self {
            return true
        }
        return false
    }
}
