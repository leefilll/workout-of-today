//
//  PopupPresentationController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class PopupPresentationController: UIPresentationController {
    
    fileprivate let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard var frame = containerView?.frame else { return .zero }
        
        frame.origin.y = frame.height / 3
        frame.size.height = 2 * frame.height / 3
        
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.alpha = 0.0
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 1.0

        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard let containerView = containerView else { return }
        
        dimmingView.alpha = 0.0
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 1.0

        }, completion: nil)
    }
}
