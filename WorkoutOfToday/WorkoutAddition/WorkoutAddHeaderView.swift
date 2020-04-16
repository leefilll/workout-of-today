//
//  AddWorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class WorkoutAddHeaderView: UIView {
    
    // MARK: Model
    
    var recentWorkouts = DBHandler.shared.fetchRecentObjects(ofType: Workout.self)
    
    // MARK: View
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    
    @IBOutlet weak var workoutPartButton: WorkoutPartButton!
    
    @IBOutlet weak var recentWorkoutCollectionView: UICollectionView!
    
    @IBOutlet weak var recentWorkoutHeaderButton: UIButton!
    
    @IBOutlet weak var setUnitLabel: UILabel!
    
    @IBOutlet weak var weightUnitLabel: UILabel!
    
    @IBOutlet weak var repsUnitLabel: UILabel!
    
    @IBOutlet weak var degreeUnitLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        self.setup()
    }
    
    private func commonInit(){
        let name = String(describing: type(of: self))
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return }
        guard let view = loadedNib.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func setup() {
        self.setUnitLabel.font = .description
        self.weightUnitLabel.font = .description
        self.repsUnitLabel.font = .description
        self.degreeUnitLabel.font = .description
        
        self.setUnitLabel.textColor = .lightGray
        self.weightUnitLabel.textColor = .lightGray
        self.repsUnitLabel.textColor = .lightGray
        self.degreeUnitLabel.textColor = .lightGray
        
        self.workoutNameTextField.font = .boldTitle
        self.workoutNameTextField.placeholder = "운동 이름"
        self.workoutNameTextField.minimumFontSize = UIFont.boldTitle.pointSize
        
        self.recentWorkoutHeaderButton.setTitle("최근 운동 접기", for: .normal)
        self.recentWorkoutHeaderButton.setTitle("최근 운동 펼치기", for: .selected)
        self.recentWorkoutHeaderButton.titleLabel?.font = .description
        self.recentWorkoutHeaderButton.setTitleColor(.lightGray, for: .normal)
        self.recentWorkoutHeaderButton.addTarget(self, action: #selector(foldCollectionView(_:)), for: .touchDown)
        
        self.recentWorkoutCollectionView.backgroundColor = .clear
//        self.recentWorkoutCollectionView.clipsToBounds = true
//        self.recentWorkoutCollectionView.layer.cornerRadius = 10
        self.recentWorkoutCollectionView.delegate = self
        self.recentWorkoutCollectionView.dataSource = self
        self.recentWorkoutCollectionView.register(RecentWorkoutCollectionViewCell.self)
        
    }
}

// MARK: objc functions

extension WorkoutAddHeaderView {
    @objc func foldCollectionView(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.recentWorkoutCollectionView.isHidden = sender.isSelected
//        if sender.isSelected {
//            self.recentWorkoutCollectionView.transform = CGAffineTransform(scaleX: 0, y: -100)
//        } else {
//            self.recentWorkoutCollectionView.transform = .identity
//        }
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: Recent CollectionView Delegate

extension WorkoutAddHeaderView: UICollectionViewDelegate {
    
}

// MARK: Recent CollectionView DataSource

extension WorkoutAddHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentWorkouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecentWorkoutCollectionViewCell.self, for: indexPath)
        let workout = self.recentWorkouts[indexPath.item]
        cell.workout = workout
        return cell
    }
}


extension WorkoutAddHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let workout = self.recentWorkouts[indexPath.item]
        let workoutName = workout.name
        let itemSize = workoutName.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldBody
        ])

        return CGSize(width: itemSize.width + 25, height: self.recentWorkoutCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}
