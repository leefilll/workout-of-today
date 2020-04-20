//
//  SlideAnimationController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import SnapKit

class PopupAnimationController: NSObject {
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    // MART: init
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension PopupAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black
        dimmingView.frame = containerView.bounds
        
        
        switch animationType {
            case .present:
                guard let toVC = transitionContext.viewController(forKey: .to) as? TodayAddWorkoutViewController,
                    
                    let fromVC = transitionContext.viewController(forKey: .from)?.children[1].children.first as? TodayWorkoutViewController else {
                        transitionContext.completeTransition(false)
                        return
                }
                
                guard let fromButton = fromVC.workoutAddButton,
                    let toButton = toVC.workoutAddButton,
                    let toContainerView = toVC.containerView
                    else { return }
                
                let tap = UITapGestureRecognizer(target: toVC, action: #selector(toVC.dismiss(_:)))
                dimmingView.addGestureRecognizer(tap)
                
                dimmingView.alpha = 0.0
                
                containerView.insertSubview(dimmingView, at: 0)
                
                let startFrameForButton = fromButton.frame
//                let startFrameForContainerView = CGRect(origin: containerView.center,
//                                                        size: .zero)
                
                
                
                
                
                
                let containerViewMinY = containerView.bounds.height / 5
                let containerViewHeight = containerView.bounds.height * 0.5
                
                let containerViewSize = CGSize(width: containerView.bounds.width,
                                               height: containerViewHeight)
                let containerVierStartPoint = CGPoint(x: 0,
                                                      y: -containerViewHeight)
                
                
                let startFrameForContainerView = CGRect(origin: containerVierStartPoint,
                                                        size: containerViewSize)
                
                
                let finalFrameForContainerView = CGRect(x: 0,
                                                        y: containerViewMinY,
                                                        width: containerView.bounds.width,
                                                        height: containerViewHeight)
                
                
                // below containerView
                let posY = finalFrameForContainerView.height
                    + finalFrameForContainerView.minY
                    + 10
                
                let finalFrameForButtton = CGRect(x: startFrameForButton.minX,
                                                  y: posY,
                                                  width: startFrameForButton.width,
                                                  height: startFrameForButton.height)
                
                
                toContainerView.frame = startFrameForContainerView
                toButton.frame = startFrameForButton
                
                containerView.addSubview(toContainerView)
                containerView.addSubview(toButton)
                
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.55,
                               options: .curveEaseInOut,
                               animations: {
                                 toContainerView.frame = finalFrameForContainerView
                                toButton.frame = finalFrameForButtton
                                dimmingView.alpha = 0.5
                                fromButton.alpha = 0.0
                }) { (finished) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                break
            
            case .dismiss:
                guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayAddWorkoutViewController,
                    let toVC = transitionContext.viewController(forKey: .to)?.children[1].children.first as? TodayWorkoutViewController,
                    let fromContainerView = fromVC.containerView,
                    let fromButton = fromVC.workoutAddButton,
                    let toButton = toVC.workoutAddButton else {
                        transitionContext.completeTransition(false)
                        return
                }
                
                dimmingView.alpha = 0.5
                
                let startFrameForButton = fromButton.frame
                let finalFrameForButton = toButton.frame
                let finalFrameForContainerView = CGRect(origin: containerView.center, size: .zero)
                
                fromButton.frame = startFrameForButton
                
                containerView.insertSubview(dimmingView, at: 0)
                containerView.addSubview(fromContainerView)
                containerView.addSubview(fromButton)
                
                
//                UIView.animate(withDuration: animationDuration,
//                               animations: {
//                               fromContainerView.frame = finalFrameForContainerView
//                                fromButton.frame = finalFrameForButton
//                                dimmingView.alpha = 0
//                }) { (finished) in
//                    toButton.alpha = 1.0
//
//                                       fromContainerView.removeFromSuperview()
//
//                                       transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//                }
//
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               usingSpringWithDamping: 0.55,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseInOut,
                               animations: {
                                dimmingView.alpha = 0
                                fromContainerView.frame = finalFrameForContainerView
                                fromButton.frame = finalFrameForButton

                }) { (finished) in
                    toButton.alpha = 1.0
                    dimmingView.removeFromSuperview()
                    fromContainerView.removeFromSuperview()

                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                break
        }
    }
    
}

