//
//  SlidePresentationController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class SlidePresentationController: UIPresentationController {
    
    private let dimmingView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        return effectView
    }()
    
    private var heightRatio: CGFloat = 1.0
    
    private var animationType: AnimationType = .present
    
    enum AnimationType {
        case present
        case dismiss
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, heighRatio: CGFloat) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.heightRatio = heighRatio
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard var frame = containerView?.frame else { return .zero }
        frame.origin.y = frame.height * (1 - heightRatio)
        frame.size.height = frame.height * heightRatio
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.alpha = 0.0
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition:{ context in
            self.dimmingView.alpha = 1
        } , completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        let tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        dimmingView.addGestureRecognizer(tapGestureRecognize)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition:{ context in
            self.dimmingView.alpha = 0.0
        } , completion: nil)
    }
    
    @objc
    func dismiss(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

