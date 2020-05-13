//
//  SummaryView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class SummaryView: BaseCardView, NibLoadable {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
    
    override func setup() {
        commonInit()
        
        subtitleLabel.font = .subheadline
        subtitleLabel.textColor = .lightGray
        
        unitLabel.font = .subheadline
        unitLabel.textColor = .lightGray
        
        titleLabel.font = .boldTitle
        
        subtitleLabel.textColor = .defaultTextColor
        unitLabel.textColor = .defaultTextColor
        titleLabel.textColor = .defaultTextColor
    }
}
