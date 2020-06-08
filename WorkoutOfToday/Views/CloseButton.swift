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
        let xmarkImage = UIImage(named: "xmark")
        
        xmarkImage?.withRenderingMode(.alwaysTemplate)
        customView.setBackgroundImage(xmarkImage, for: .normal)
        customView.addTarget(target, action: action, for: .touchUpInside)
//        customView.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.customView = customView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
