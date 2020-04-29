//
//  HighlightsView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class HighlightsView: BaseCardView, NibLoadable {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var chartView: UIView!
    
    override func setup() {
        commonInit()
        
        subtitleLabel.font = .subheadline
        subtitleLabel.textColor = .lightGray
        
        chartView.backgroundColor = .clear
    }
}
