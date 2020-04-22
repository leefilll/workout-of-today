//
//  HighlightsTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class HighlightsTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            self.containerView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        } else {
            self.containerView.backgroundColor = UIColor.white
        }
    }
    
    override func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        titleLabel.font = .smallBoldTitle
    }
}
