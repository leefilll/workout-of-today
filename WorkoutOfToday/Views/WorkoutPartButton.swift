//
//  WorkoutPartCircleView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class WorkoutPartButton: UIButton {
    
    var part: Part? {
        didSet {
            self.backgroundColor = self.part?.color
            self.setTitle(self.part?.description, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.part = Part.none
        
        self.setTitle("파트", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .subheadline
        self.backgroundColor = self.part?.color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
}
