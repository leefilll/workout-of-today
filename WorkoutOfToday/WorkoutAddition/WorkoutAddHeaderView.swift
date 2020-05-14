//
//  AddWorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

final class WorkoutAddHeaderView: BaseView, NibLoadable {
    
    // MARK: Model
    
    var workout: Workout? {
        didSet {
            nameTextField.text = workout?.name
            partButton.part = workout?.part
        }
    }
    
    // MARK: View
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var partButton: WorkoutPartButton!
    
    @IBOutlet weak var equipmentButton: WorkoutPartButton!
    
    @IBOutlet weak var recentWorkoutHeaderButton: UIButton!
    
    @IBOutlet weak var recentWorkoutCollectionView: UICollectionView!
    
    @IBOutlet weak var setUnitLabel: UILabel!
    
    @IBOutlet weak var weightUnitLabel: UILabel!
    
    @IBOutlet weak var repsUnitLabel: UILabel!
    
    @IBOutlet weak var degreeUnitLabel: UILabel!
    
    deinit {
        print("vc deinit - AddHeaderViewDeinited")
        print("vc deinit - AddHeaderViewDeinited")
        print("vc deinit - AddHeaderViewDeinited")
        print("vc deinit - AddHeaderViewDeinited")
    }
    
    override func setup() {
        self.commonInit()
        
        self.setUnitLabel.font = .description
        self.weightUnitLabel.font = .description
        self.repsUnitLabel.font = .description
        self.degreeUnitLabel.font = .description
        
        self.setUnitLabel.textColor = .lightGray
        self.weightUnitLabel.textColor = .lightGray
        self.repsUnitLabel.textColor = .lightGray
        self.degreeUnitLabel.textColor = .lightGray
        
        self.nameTextField.font = .boldTitle
        self.nameTextField.placeholder = "운동 이름"
        self.nameTextField.minimumFontSize = UIFont.boldTitle.pointSize
        
        self.recentWorkoutHeaderButton.isSelected = false
        self.recentWorkoutHeaderButton.clipsToBounds = true
        self.recentWorkoutHeaderButton.layer.cornerRadius = 10
        self.recentWorkoutHeaderButton.setTitle("최근 운동", for: .normal)
        self.recentWorkoutHeaderButton.setTitleColor(.tintColor, for: .selected)
        self.recentWorkoutHeaderButton.setTitleColor(.lightGray, for: .normal)
        self.recentWorkoutHeaderButton.setBackgroundColor(UIColor.tintColor.withAlphaComponent(0.1), for: .selected)
        self.recentWorkoutHeaderButton.setBackgroundColor(UIColor.concaveColor.withAlphaComponent(0.7), for: .normal)
        self.recentWorkoutHeaderButton.titleLabel?.font = .subheadline
        self.recentWorkoutHeaderButton.setTitleColor(.lightGray, for: .normal)
        self.recentWorkoutHeaderButton.addTarget(self, action: #selector(foldCollectionView(_:)), for: .touchDown)
        
        self.recentWorkoutCollectionView.isHidden = true
        self.recentWorkoutCollectionView.backgroundColor = .clear
    }
}

// MARK: objc functions

extension WorkoutAddHeaderView {
    @objc func foldCollectionView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.recentWorkoutCollectionView.isHidden = !sender.isSelected
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.75, options:[.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        self.setUnitLabel.isHidden = sender.isSelected
        self.weightUnitLabel.isHidden = sender.isSelected
        self.repsUnitLabel.isHidden = sender.isSelected
        self.degreeUnitLabel.isHidden = sender.isSelected
    }
}
//
//// MARK: Recent CollectionView Delegate
//
//extension WorkoutAddHeaderView: UICollectionViewDelegate {
//
//}
//
//// MARK: Recent CollectionView DataSource
//
//extension WorkoutAddHeaderView: UICollectionViewDataSource {
//
//}
//
//
//extension WorkoutAddHeaderView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let workout = self.recentWorkouts[indexPath.item]
//        let workoutName = workout.name
//        let itemSize = workoutName.size(withAttributes: [
//            NSAttributedString.Key.font : UIFont.boldBody
//        ])
//
//        return CGSize(width: itemSize.width + 25, height: self.recentWorkoutCollectionView.bounds.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//
//}
