//
//  Feedbackable.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/02.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

protocol Feedbackable {}

extension Feedbackable where Self: BasicViewController {
    func prepareFeedback() {
        selectionFeedbackGenerator?.prepare()
        impactFeedbackGenerator?.prepare()
    }
}
