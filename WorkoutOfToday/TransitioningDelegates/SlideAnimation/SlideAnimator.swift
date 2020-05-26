//
//  SlideAnimator.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration: Double
    
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
            
            // MARK: Present animation
            
            case .present:
                guard let toVC = transitionContext.viewController(forKey: .to) else { return }
                let containerView = transitionContext.containerView
                
                let height = toVC.view.bounds.height
                toVC.view.transform = toVC.view.transform.translatedBy(x: 0, y: height)
                toVC.view.clipsToBounds = true
                toVC.view.layer.cornerRadius = Size.cornerRadius
                
                containerView.addSubview(toVC.view)
                
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               usingSpringWithDamping: 0.95,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                               animations: {
                    toVC.view.transform = .identity
                }) { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
//
//                UIView.animate(withDuration: animationDuration,
//                               animations: {
//                                toVC.view.transform = .identity
//                }) { finished in
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            }
            
            // MARK: Dismiss animation
            
            case .dismiss:
                guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
                let containerView = transitionContext.containerView
                let height = fromVC.view.bounds.height
                
                containerView.addSubview(fromVC.view)
                UIView.animate(withDuration: animationDuration, animations: {
                    fromVC.view.transform = fromVC.view.transform.translatedBy(x: 0, y: height)
                }, completion: { finished in
                    fromVC.view.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
        }
    }
}


