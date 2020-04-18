//
//  AddWorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

final class WorkoutAddHeaderView: UIView {
    
    // MARK: Model
    
    var recentWorkouts: Results<Workout>!
    
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
    
    deinit {
        print("vc deinit - AddHeaderViewDeinited")
        print("vc deinit - AddHeaderViewDeinited")
        print("vc deinit - AddHeaderViewDeinited")
        print("vc deinit - AddHeaderViewDeinited")
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
        self.recentWorkouts = DBHandler.shared.fetchRecentObjects(ofType: Workout.self)
        
        print("In addVC")
        for w in recentWorkouts {
            print("\(w.name) - \(w.id)")
        }
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
        self.recentWorkoutCollectionView.delegate = self
        self.recentWorkoutCollectionView.dataSource = self
        self.recentWorkoutCollectionView.register(RecentWorkoutCollectionViewCell.self)
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
