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
        
        
        switch animationType {
            
            // MARK: PRESENT
            
            case .present:
                guard let toVC = transitionContext.viewController(forKey: .to) as? TodayAddWorkoutViewController,
                    let fromVC = transitionContext.viewController(forKey: .from)?.children[1].children.first as? TodayWorkoutViewController,
                    let toView = toVC.view,
                    let fromButton = fromVC.workoutAddButton,
                    let toButton = toVC.workoutAddButton
                    else {
                        transitionContext.completeTransition(false)
                        return
                }
                
                let dimmingView = UIView()
                dimmingView.backgroundColor = .black
                dimmingView.frame = containerView.bounds
                dimmingView.alpha = 0.0
                
                let tap = UITapGestureRecognizer(target: toVC, action: #selector(toVC.dismiss(_:)))
                dimmingView.addGestureRecognizer(tap)
                
                containerView.insertSubview(dimmingView, at: 0)
                containerView.addSubview(toView)
                containerView.addSubview(toButton)
                
                let startPoint = CGPoint(x: 0, y: -toView.bounds.height)
                let finalWidth: CGFloat = fromButton.bounds.width
                let finalHeightt: CGFloat = 300
                let finalSize = CGSize(width: finalWidth, height: finalHeightt)
                
                
                let startFrame = CGRect(origin: startPoint, size: finalSize)
//                let finalPoint = CGPoint(x: fromButton.frame.minX,
//                                         y: containerView.bounds.height / 5)
//                let finalPoint = containerView.center
//                var finalFrame = CGRect(origin: finalPoint, size: finalSize)

                // below containerView
                let posY = containerView.center.y
                    + finalSize.height / 2
                    + 10
                
                let startFrameForButton = fromButton.frame
                let finalFrameForButtton = CGRect(x: startFrameForButton.minX,
                                                  y: posY,
                                                  width: startFrameForButton.width,
                                                  height: startFrameForButton.height)

                fromButton.alpha = 0.0
                toView.frame = startFrame
                toButton.frame = startFrameForButton
                
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               usingSpringWithDamping: 0.75,
                               initialSpringVelocity: 0.85,
                               options: .curveLinear,
                               animations: {
                                toView.center = containerView.center
//                                toView.frame = finalFrame
                                toButton.frame = finalFrameForButtton
                                dimmingView.alpha = 0.5

                }) { (finished) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                break
            
            
            // MARK: DISMISS
            
            case .dismiss:
                guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayAddWorkoutViewController,
                    let toVC = transitionContext.viewController(forKey: .to)?.children[1].children.first as? TodayWorkoutViewController,
                    let fromView = fromVC.view,
                    let fromButton = fromVC.workoutAddButton,
                    let toButton = toVC.workoutAddButton else {
                        transitionContext.completeTransition(false)
                        return
                }
                
                let dimmingView = containerView.subviews.first!
                containerView.insertSubview(dimmingView, at: 0)
                containerView.addSubview(fromView)
                containerView.addSubview(fromButton)

                let startFrameForButton = fromButton.frame
                let finalFrameForButton = toButton.frame
                
                let finalPoint = fromView.center
                let finalFrame = CGRect(origin: finalPoint, size: .zero)

                fromButton.frame = startFrameForButton
                fromView.translatesAutoresizingMaskIntoConstraints = true
                
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               usingSpringWithDamping: 0.85,
                               initialSpringVelocity: 0.88,
                               options: .curveEaseInOut,
                               animations: {
                                dimmingView.alpha = 0
                                fromView.frame = finalFrame
                                fromButton.frame = finalFrameForButton

                }) { (finished) in
                    toButton.alpha = 1.0
                    dimmingView.removeFromSuperview()
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                break
        }
    }
    
}

