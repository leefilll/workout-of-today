//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class TodayAddWorkoutViewController: BaseViewController {
    
    // MARK: Model
    
    fileprivate var dummyData: [Workout] = {
        var lst = [Workout]()
        
        let workout1 = Workout()
        workout1.part = Part.back
        workout1.name = "존나긴 데드리프트"
        
        let workout2 = Workout()
        workout2.part = Part.chest
        workout2.name = "평범한 벤치프"
        
        let workout3 = Workout()
        workout3.part = Part.legs
        workout3.name = "Squat"
        
        let workout4 = Workout()
        workout4.part = Part.core
        workout4.name = "Squatdfsf"
        
        let workout5 = Workout()
        workout5.part = Part.chest
        workout5.name = "dfsdfsfs"
        
        let workout6 = Workout()
        workout6.part = Part.shoulder
        workout6.name = "Mlirary Press"
        
        let workout7 = Workout()
        workout7.part = Part.body
        workout7.name = "Squatdfsf"
        
        lst.append(workout1)
        lst.append(workout2)
        lst.append(workout3)
        lst.append(workout4)
        lst.append(workout5)
        lst.append(workout6)
        lst.append(workout7)
        
        return lst
    }()
    
    var tempWorkout: Workout! {         // temporary workout for settings
        didSet {
            view.layoutIfNeeded()
        }
    }
    
    var workoutsOfDay: WorkoutsOfDay?   // passed from TodayVC
    
    var recentWorkouts: [Workout]?      // recent Objects for collectionView
    
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!

    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    fileprivate var originMinY: CGFloat!
    
    fileprivate var originMaxY: CGFloat!
    
    fileprivate var minimumVelocityToHide: CGFloat = 1200
    
    fileprivate var minimumScreenRatioToHide: CGFloat = 0.3
    
    fileprivate var animationDuration: TimeInterval = 0.2
    
    // MARK: View
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var closeButton: BaseButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var recentDescLabel: UILabel!
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    @IBOutlet weak var handleView: UIView!
    
    override func setup() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(containerViewDidTapped(_:)))
//        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        handleView.backgroundColor = .lightGray
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.5
        tempWorkout = Workout()
        
        setupLabels()
        setupCloseButton()
        setupCollectionView()
        setupPanGestureRecognizer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originMinY = view.frame.minY
        originMaxY = view.frame.maxY
    }
    
    fileprivate func setupLabels() {
        titleLabel.font = .boldTitle
        titleLabel.text = "운동 추가"
        
        recentDescLabel.font = .description
        recentDescLabel.textColor = .lightGray
        recentDescLabel.text = "최근 운동"
    }
    
    fileprivate func setupCloseButton() {
        closeButton.setTitle("닫기" , for: .normal)
        closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupCollectionView() {
//        recentWorkouts = DBHandler.shared.fetchRecentObjects(ofType: Workout.self)
        
        if let layout = recentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: 105, height: 130)
        }
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        recentCollectionView.delaysContentTouches = false
        recentCollectionView.registerByNib(TodayWorkoutAddCollectionViewCell.self)
    }
    
    fileprivate func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidTapped(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

}

// MARK: objc functions

extension TodayAddWorkoutViewController {
    @objc
    func containerViewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func dismiss(_ sender: UITapGestureRecognizer?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func panGestureDidTapped(_ sender: UIPanGestureRecognizer) {
        func slideViewVerticallyTo(_ y: CGFloat) {
            view.frame.origin = CGPoint(x: 0, y: y)
        }
        
        switch sender.state {
            case .began, .changed:
                let translation = sender.translation(in: view)
                let y = max(originMinY, originMinY + translation.y)
                slideViewVerticallyTo(y)
            case .ended:
                let translation = sender.translation(in: view)
                let velocity = sender.velocity(in: view)
                let closing = (translation.y > view.frame.height * minimumScreenRatioToHide) ||
                    (velocity.y > minimumVelocityToHide)
                
                if closing {
                    UIView.animate(withDuration: animationDuration, animations: {
                        slideViewVerticallyTo(self.originMaxY)
                    }, completion: { (isCompleted) in
                        if isCompleted {
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                } else {
                    UIView.animate(withDuration: animationDuration, animations: {
                        slideViewVerticallyTo(self.originMinY)
                    })
            }
            default:
                UIView.animate(withDuration: animationDuration, animations: {
                    slideViewVerticallyTo(self.originMinY)
                })
        }
    }
}

// MARK: CollectionView Delegate

extension TodayAddWorkoutViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWorkout = dummyData[indexPath.item]
        guard let newWorkout = selectedWorkout.copy() as? Workout else { return }
        if let workoutsOfDay = workoutsOfDay {
            // if WOD already exists
            DBHandler.shared.write {
                workoutsOfDay.workouts.append(newWorkout)
            }
        } else {
            let newWorkoutsOfDay = WorkoutsOfDay()
            DBHandler.shared.create(object: newWorkoutsOfDay)
            DBHandler.shared.write {
                newWorkoutsOfDay.workouts.append(newWorkout)
            }
            // MARK: Should fix this
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CollectionView DataSourec

extension TodayAddWorkoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TodayWorkoutAddCollectionViewCell.self,
                                                      for: indexPath)
        
        cell.workout = dummyData[indexPath.item]
        return cell
    }
}

// MARK: CollectionView Delegate Flow Layout

extension TodayAddWorkoutViewController: UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////        guard let workout = recentWorkouts?[indexPath.item] else { return .zero }
//        let workout = dummyData[indexPath.item]
//
//        let workoutName = workout.name
//        let itemSize = workoutName.size(withAttributes: [
//            NSAttributedString.Key.font : UIFont.smallBoldTitle
//        ])
//
//        let extraWidth: CGFloat = 65
//
//        return CGSize(width: itemSize.width + extraWidth,
//                      height: Size.AddCollectionViewHeight)
//    }
}


// MARK: TextField Delegate

extension TodayAddWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        tempWorkout?.name = text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
