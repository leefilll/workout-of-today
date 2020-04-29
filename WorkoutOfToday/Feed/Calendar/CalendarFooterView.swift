//
//  CalendarFooterView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class CalendarFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        containerView.backgroundColor = .white
    }
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.setRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
}
