//
//  AddWorkoutFooterView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class WorkoutSetAddFooterView: UITableViewHeaderFooterView, NibLoadable {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var workoutSetAddButton: UIButton!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        print("vc deinit - footerView")
        print("vc deinit - footerView")
        print("vc deinit - footerView")
        print("vc deinit - footerView")
        print("vc deinit - footerView")
    }
    
    private func setup() {
        commonInit()
        
        containerView.backgroundColor = .white
        
        workoutSetAddButton.setTitle("세트 추가", for: .normal)
        workoutSetAddButton.setTitleColor(UIColor.tintColor, for: .normal)
        workoutSetAddButton.titleLabel?.font = .boldBody
        workoutSetAddButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.1)
        workoutSetAddButton.clipsToBounds = true
        workoutSetAddButton.layer.cornerRadius = 10
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.setRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
}
