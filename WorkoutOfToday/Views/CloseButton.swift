//
//  CloseButton.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/28.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class CloseButton: UIBarButtonItem {
    
    init(target: AnyObject, action: Selector) {
        super.init()
        self.target = target
        self.action = action
        self.style = .plain
        let customView = UIButton()
        customView.setBackgroundImage(UIImage(named: "xmark"), for: .normal)
        customView.addTarget(target, action: action, for: .touchUpInside)
        self.customView = customView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
