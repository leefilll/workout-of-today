//
//  BaseTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/22.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
    override func awakeFromNib() {
        setup()
    }
    
    public func setup() {
        contentView.backgroundColor = .clear
    }
    
}
