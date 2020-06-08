//
//  BaseCardView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/23.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BasicCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setup()
//    }
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = Size.cornerRadius
    }
}
