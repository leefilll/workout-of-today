//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class TodayAddWorkoutViewController: BasicViewController {
    
    // MARK: Model
    
//    fileprivate var templates: Results<WorkoutTemplate>!
    
    fileprivate var templates: [[WorkoutTemplate]] {
        let templates = DBHandler.shared.fetchObjects(ofType: WorkoutTemplate.self)
        var partArray = [[WorkoutTemplate]](repeating: [], count: Part.allCases.count)
        templates.forEach { template in
            let rawValue = template.part.rawValue
            partArray[rawValue].append(template)
        }
        return partArray
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
    
    fileprivate let popupTransitioningDelegateForTemplate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.50)
    
    // MARK: View
    
    @IBOutlet weak var editTemplateButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var templateCollectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func setup() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(containerViewDidTapped(_:)))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        setupEditTemplateButton()
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
    
    override func configureNavigationBar() {
        navigationBar.topItem?.title = "운동 추가"
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
    
    fileprivate func setupEditTemplateButton() {
        editTemplateButton.title = "템플릿"
        editTemplateButton.action = #selector(editTemplateButtonDidTapped(_:))
    }
    
    fileprivate func setupCollectionView() {
        if let layout = templateCollectionView.collectionViewLayout as? FeedCollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        templateCollectionView.delegate = self
        templateCollectionView.dataSource = self
        templateCollectionView.delaysContentTouches = false
        templateCollectionView.registerByNib(TodayWorkoutAddCollectionViewCell.self)
        templateCollectionView.registerForHeaderView(TodayAddWorkoutCollectionHeaderView.self)
    }
    
    fileprivate func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidTapped(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: AddWorkoutTemplate Delegate

extension TodayAddWorkoutViewController: AddWorkoutTemplate {
    func workoutTemplateDidAdded() {
        templateCollectionView.reloadData()
    }
}

// MARK: objc functions

extension TodayAddWorkoutViewController {
    @objc
    func containerViewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func editTemplateButtonDidTapped(_ sender: UITapGestureRecognizer?) {
        let templateAddVC = TodayWorkoutTemplateAddViewController(nibName: "TodayWorkoutTemplateAddViewController", bundle: nil)
        templateAddVC.modalPresentationStyle = .custom
        templateAddVC.transitioningDelegate = popupTransitioningDelegateForTemplate
        templateAddVC.delegate = self
        present(templateAddVC, animated: true, completion: nil)
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
        let selectedTemplate = templates[indexPath.section][indexPath.item]
        let newWorkout = Workout()
        guard let workoutsOfDay = workoutsOfDay else { return }
        DBHandler.shared.write {
            workoutsOfDay.workouts.append(newWorkout)
            selectedTemplate.workouts.append(newWorkout)
        }
//        if let workoutsOfDay = workoutsOfDay {
//            // if WOD already exists
//            DBHandler.shared.write {
//                workoutsOfDay.workouts.append(newWorkout)
//            }
//        } else {
//            let newWorkoutsOfDay = WorkoutsOfDay()
//            DBHandler.shared.create(object: newWorkoutsOfDay)
//            DBHandler.shared.write {
//                newWorkoutsOfDay.workouts.append(newWorkout)
//            }
//            // MARK: Should fix this
//        }
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if templates[section].count == 0 {
            return .zero
        }
        return CGSize(width: 0, height: 40)
    }
}

// MARK: CollectionView DataSourec

extension TodayAddWorkoutViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dummyData.count
        return templates[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(TodayAddWorkoutCollectionHeaderView.self, for: indexPath)
        let part = Part.allCases[indexPath.section]
        header.titleLabel.text = part.description
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TodayWorkoutAddCollectionViewCell.self,
                                                      for: indexPath)
        cell.template = templates[indexPath.section][indexPath.item]
        return cell
    }
}

// MARK: CollectionView Delegate Flow Layout

extension TodayAddWorkoutViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let workoutTemplate = templates[indexPath.section][indexPath.item]
        let templateString = workoutTemplate.name
        let itemSize = templateString.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.smallBoldTitle
        ])

        let extraWidth: CGFloat = 30
        let insetHorizontal = collectionView.contentInset.left + collectionView.contentInset.right
        let maxWidth = collectionView.bounds.width - insetHorizontal
        
        if itemSize.width + extraWidth > maxWidth {
            return CGSize(width: maxWidth, height: Size.addCollectionViewHeight)
        }
        return CGSize(width: itemSize.width + extraWidth,
                      height: Size.addCollectionViewHeight)
    }
}

// MARK: TextField Delegate

extension TodayAddWorkoutViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
