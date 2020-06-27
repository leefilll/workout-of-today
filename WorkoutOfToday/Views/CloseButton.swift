//
//  CloseButton.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/28.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import SwiftIcons

class CloseButton: UIBarButtonItem {
    
    init(target: AnyObject, action: Selector) {
        super.init()
        self.target = target
        self.action = action
        self.setIcon(icon: .ionicons(.iosClose), iconSize: 29, color: .lightGray2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
