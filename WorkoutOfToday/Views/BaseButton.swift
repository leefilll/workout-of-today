//
//  BaseButton.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    
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
        self.setTitleColor(.lightGray, for: .normal)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.font = .description
    }
}

