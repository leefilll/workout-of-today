//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import DZNEmptyDataSet
import SwiftIcons

class TodayAddWorkoutViewController: WorkoutTemplateViewController {
    
    // MARK: Model
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private var originMinY: CGFloat!
    
    private var originMaxY: CGFloat!
    
    private var minimumVelocityToHide: CGFloat = 1200
    
    private var minimumScreenRatioToHide: CGFloat = 0.3
    
    private var animationDuration: TimeInterval = 0.2
    
    private let popupTransitioningDelegateForTemplate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.50)
    
    override var navigationBarTitle: String {
        return "운동 추가"
    }
    
    override func setup() {
        super.setup()
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(containerViewDidTapped(_:)))
        templateCollectionView.delegate = self
        templateCollectionView.emptyDataSetDelegate = self
        templateCollectionView.emptyDataSetSource = self
        setupEditTemplateButton()
        setupPanGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originMinY = view.frame.minY
        originMaxY = view.frame.maxY
    }
    
    private func setupEditTemplateButton() {
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editTemplateButtonDidTapped(_:)))
    }
    
    private func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidBegin(_:)))
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
    func editTemplateButtonDidTapped(_ sender: UITapGestureRecognizer?) {
        let templateAddVC = TodayWorkoutTemplateAddViewController(nibName: "TodayWorkoutTemplateAddViewController", bundle: nil)
        templateAddVC.modalPresentationStyle = .custom
        templateAddVC.transitioningDelegate = popupTransitioningDelegateForTemplate
        templateAddVC.delegate = self
        present(templateAddVC, animated: true, completion: nil)
    }
    
    @objc
    func panGestureDidBegin(_ sender: UIPanGestureRecognizer) {
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

extension TodayAddWorkoutViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTemplate = templates[indexPath.section][indexPath.item]
        
        DBHandler.shared.write {
            let newWorkout = Workout()
            newWorkout.template = selectedTemplate
            DBHandler.shared.realm.add(newWorkout)
        }
        
        postNotification(.WorkoutDidAdded)
        selectionFeedbackGenerator?.selectionChanged()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: DZNEmptyDataSet DataSource and Delegate

extension TodayAddWorkoutViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        for template in templates {
            if !template.isEmpty {
                return false
            }
        }
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let iconImage = UIImage.init(icon: .ionicons(.iosInformationOutline),
                                     size: CGSize(width: 70, height: 70),
                                     textColor: .lightGray)
        return iconImage
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "운동 템플릿이 없습니다"
        let font = UIFont.smallBoldTitle
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "운동 템플릿을 등록하면\n간편하게 운동을 추가할 수 있습니다."
        let font = UIFont.subheadline
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        editTemplateButtonDidTapped(nil)
    }
}
