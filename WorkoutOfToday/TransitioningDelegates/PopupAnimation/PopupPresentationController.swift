//
//  PopupPresentationController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class PopupPresentationController: UIPresentationController {
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        return view
    }()
    
    private var widthRatio: CGFloat = 0.95
    
    private var heightRatio: CGFloat = 1.0
    
    private var height: CGFloat = 0
    
    private var animationType: AnimationType = .present
    
    private var presentationType: PresentationType = .ratio
    
    private var minY: CGFloat?
    
    enum PresentationType {
        case ratio
        case concrete
    }
    
    enum AnimationType {
        case present
        case dismiss
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, widthRatio: CGFloat, heighRatio: CGFloat, minY: CGFloat? = nil) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.presentationType = .ratio
        self.widthRatio = widthRatio
        self.heightRatio = heighRatio
        self.minY = minY
    }
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.presentationType = .concrete
        self.height = height
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard var frame = containerView?.frame else { return .zero }
        switch presentationType {
            case .concrete:
                if let minY = minY {
                    frame.origin.y = minY
                } else {
                    frame.origin.y = (frame.height - height) / 2
                }
                frame.origin.x = frame.width * (1 - widthRatio) / 2
                frame.size.height = height
                frame.size.width = frame.width * widthRatio
                break
            case .ratio:
                if let minY = minY {
                    frame.origin.y = minY
                } else {
                    frame.origin.y = frame.height * (1 - heightRatio) / 2
                }
                frame.origin.x = frame.width * (1 - widthRatio) / 2
                frame.size.height = frame.height * heightRatio
                frame.size.width = frame.width * widthRatio
                break
        }
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
            self.dimmingView.alpha = 1.0
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

