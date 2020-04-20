//
//  TodayWorkoutAddView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutAddView: BaseView, NibLoadable {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var partButton: WorkoutPartButton!
    
    @IBOutlet weak var equipmentButton: WorkoutPartButton!
    
    @IBOutlet weak var recentButton: WorkoutPartButton!
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    enum Button {
        static let partButton = 0
        static let equipmentButton = 1
        static let recentButton = 2
    }
    
    override func setup() {
        commonInit()
        
        nameTextField.font = .boldTitle
        nameTextField.placeholder = "운동 이름"
        nameTextField.minimumFontSize = UIFont.boldTitle.pointSize
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.tintColor = .tintColor
        
        partButton.tag = Button.partButton
        equipmentButton.tag = Button.equipmentButton
        recentButton.tag = Button.recentButton
        
        partButton.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        equipmentButton.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        recentButton.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    func buttonDidTapped(_ sender: UIButton) {
    }
}
