//
//  WorkoutPartCircleView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class WorkoutPartButton: UIButton {
    
    public var partRawValue: Part.RawValue? {
        didSet {
            self.part = Part(rawValue: self.partRawValue ?? 0)
        }
    }
    
    private var part: Part? = Part.none {
        didSet {
            self.backgroundColor = self.part?.color.withAlphaComponent(0.2)
            self.setTitleColor(self.part?.color, for: .normal)
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
        self.sizeToFit()
        self.part = Part.none
        
        self.setTitle("파트", for: .normal)
        self.titleLabel?.font = .subheadline
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
}
