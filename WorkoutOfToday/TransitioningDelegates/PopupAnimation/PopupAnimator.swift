//
//  PopupDismissalAnimator.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class PopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
                
                toVC.view.alpha = 0.0
                toVC.view.transform = toVC.view.transform.scaledBy(x: 0.7, y: 0.7)
                toVC.view.clipsToBounds = true
                toVC.view.layer.cornerRadius = Size.cornerRadius
                
                containerView.addSubview(toVC.view)
                
                UIView.animate(withDuration: animationDuration, animations: {
                    toVC.view.alpha = 1.0
                    toVC.view.transform = .identity
                }, completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            
            // MARK: Dismiss animation
            
            case .dismiss:
                guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
                let containerView = transitionContext.containerView
                
                containerView.addSubview(fromVC.view)
                UIView.animate(withDuration: animationDuration, animations: {
                    fromVC.view.alpha = 0.0
                    fromVC.view.transform = fromVC.view.transform.scaledBy(x: 0.7, y: 0.7)
                }, completion: { finished in
                    fromVC.view.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
        }
        
    }
}

