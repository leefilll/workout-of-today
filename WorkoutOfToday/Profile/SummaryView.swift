//
//  SummaryView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class SummaryView: BasicCardView, NibLoadable {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
    
    override func setup() {
        super.setup()
        commonInit()
        
        subtitleLabel.font = .boldBody
        subtitleLabel.textColor = .lightGray
        
        unitLabel.font = .boldBody
        unitLabel.textColor = .defaultTextColor
        
        mainLabel.font = .boldTitle
        mainLabel.textColor = .defaultTextColor
    }
}
