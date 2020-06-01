//
//  BaseButton.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BasicButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public func setup() {
        setTitle("", for: .normal)
        titleLabel?.font = .subheadline
        
        setTitleColor(.lightGray, for: .normal)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
        layer.cornerRadius = 10
    }
}


