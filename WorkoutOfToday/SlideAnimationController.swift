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
        switch animationType {
        case .present:
            guard let toViewController = transitionContext.viewController(forKey: .to) as? TodayAddWorkoutViewController,
                
                let fromViewController = transitionContext.viewController(forKey: .from)?.children[1].children.first as? TodayWorkoutViewController else {
                    transitionContext.completeTransition(false)
                    return
            }
            
            guard let fromButton = fromViewController.workoutAddButton,
                let toButton = toViewController.workoutAddButton,
                let toContainerView = toViewController.containerView
            else { return }

            let containerView = transitionContext.containerView
//            let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            let dimmingView = UIView()
            dimmingView.backgroundColor = .black

            dimmingView.frame = containerView.bounds
            dimmingView.alpha = 0.0
            containerView.insertSubview(dimmingView, at: 0)
            
            
            let startFrame = fromButton.frame
            let startFrameForContainerView = CGRect(origin: containerView.center,
                                                    size: .zero)
//            let finalFrameForContainerView = CGRect(x: startFrame.minX,
//                                    y: containerView.bounds.height / 4,
//                                    width: startFrame.width,
//                                    height: 400)
            let containerViewMinY = containerView.bounds.height / 5
            let containerViewHeight = containerView.bounds.height * 0.6
            let finalFrameForContainerView = CGRect(x: 0,
                                                    y: containerViewMinY,
                                                    width: containerView.bounds.width,
                                                    height: containerViewHeight)
            
            // below containerView
            let posY = finalFrameForContainerView.height
                + finalFrameForContainerView.minY
                + 10
//                - fromButton.bounds.height
            
            let finalFrameForButtton = CGRect(x: startFrame.minX,
                                              y: posY,
                                              width: startFrame.width,
                                              height: startFrame.height)
 
            
            toContainerView.frame = startFrameForContainerView
            toButton.frame = startFrame
            
            containerView.addSubview(toContainerView)
            containerView.addSubview(toButton)
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.55,
                           options: .curveEaseInOut,
                           animations: {
//                            toContainerView.isHidden = false
                            toContainerView.frame = finalFrameForContainerView
                            toButton.frame = finalFrameForButtton
                            dimmingView.alpha = 0.3
                            fromButton.isHidden = true
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
//
//            UIView.animate(
//                withDuration: animationDuration,
//                animations: {
//                    toContainerView.alpha = 1.0
//                    toButton.frame = finalFrameForButtton
//                    dimmingView.alpha = 0.3
//                    fromButton.isHidden = true
//            },
//                completion: { success in
//
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            })
//
//            containerView.addSubview(dimmingView)
//            dimmingView.alpha = 0.0
//            dimmingView.frame = containerView.bounds
//
//            containerView.addSubview(toView)
//            let translationYForPullOff = fromView.frame.height - 60
//            let pullOffTransform = CGAffineTransform(translationX: 0, y: -translationYForPullOff)
//            let targetHeight = fromView.frame.height
//            let translationYForFinal = fromView.frame.origin.y - 250
//            let moveUpTransform = CGAffineTransform(translationX: 0, y: -translationYForFinal)
//
//
//            UIView.animateKeyframes(
//                withDuration: animationDuration,
//                delay: 0,
//                options: .calculationModeLinear,
//                animations: {
//
//                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
//                        toView.transform = pullOffTransform
//                        toView.frame.size.height = targetHeight
//                    }
//
//                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
//                        toView.transform = moveUpTransform
//                    }
//                    fromView.isHidden = true
//                    dimmingView.alpha = 1.0
//
//            }) { _ in
////                containerView.snp.makeConstraints { make in
////                    make.leading.trailing.top.bottom.equalToSuperview()
////                }
////                toView.snp.makeConstraints { make in
////                    make.leading.equalTo(containerView.snp.leading).offset(10)
////                    make.trailing.equalTo(containerView.snp.trailing).offset(-10)
////                    make.center.equalTo(containerView.snp.center)
////                    make.height.equalTo(400)
////                }
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            }
//
            break
        case .dismiss:
            break
//            guard let toViewController = transitionContext.viewController(forKey: .to)?.children.first?.children.last as? WorkoutViewController,
//                let fromViewController = transitionContext.viewController(forKey: .from) as? AddWorkoutViewController,
//                let fromView = fromViewController.view else {
//                    transitionContext.completeTransition(false)
//                    return
//            }
//
//            let toView = toViewController.addWorkoutCardView
//            let dimmingView = fromViewController.dimmingView
//            let translationYForMoveDown = fromView.frame.height - 60
//            let moveDownTransform = CGAffineTransform(translationX: 0, y: -translationYForMoveDown)
//            let putInTrasnform = CGAffineTransform(translationX: 0, y: 0)
//            let targetHeight = CGFloat(60)
//
//            UIView.animateKeyframes(
//                withDuration: animationDuration,
//                delay: 0,
//                options: .calculationModeLinear,
//                animations: {
//                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
//                        fromView.transform = moveDownTransform
//                    }
//                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
//                        fromView.transform = putInTrasnform
//                        fromView.frame.size.height = targetHeight
//                    }
//                    dimmingView.alpha = 0.0
//            }) { _ in
//                toView.isHidden = false
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            }
//
////            UIView.animate(withDuration: animationDuration, animations: {
////                fromView.transform = moveDownTransform
////
////            }) { _ in
////
////                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            }
////
//
//            break
        }
    }

    func setConstraint(of view: UIView) {
        //        view.snp.makeConstraints { make in
        //            <#code#>
        //        }
    }

    func presentAnimation(using transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {

        viewToAnimate.clipsToBounds = true

        let duration = transitionDuration(using: transitionContext)

    }


}


//
//class SlideAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
//    let duration = TimeInterval(0.35)
//    //    let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//    var presenting = true
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//                if presenting {
//                    guard let fromVC = transitionContext.viewController(forKey: .from)?.children.first?.children.last as? WorkoutViewController else {fatalError()}
//                    guard let toVC = transitionContext.viewController(forKey: .to) as? AddWorkoutViewController else { fatalError() }
//                    guard let toView = toVC.view else { fatalError() }
//                    toView.frame = containerView.frame
//
//                    toView.alpha = 0.0
//                    containerView.addSubview(toView)
//                    let startFrame = fromVC.addWorkoutCardView.frame
//                    let origin = CGPoint(x: startFrame.origin.x, y: 250)
//                    let size = CGSize(width: startFrame.width, height: containerView.bounds.height - 500)
//                    let finalFrame = CGRect(origin: origin, size: size)
//
//                    let middleView = CardView(frame: startFrame)
//                    middleView.part = .entire
//                    middleView.backgroundColor = .red
//                    middleView.clipsToBounds = true
//                    middleView.contentMode = .scaleAspectFill
//                    containerView.addSubview(middleView)
//
//
//                    UIView.animate(withDuration: duration, animations: {
//                        middleView.frame = finalFrame
//                            fromVC.addWorkoutCardView.isHidden = true
//                        }, completion: { finised in
//                            let success = !transitionContext.transitionWasCancelled
//                            toView.alpha = 1.0
//                            middleView.alpha = 0.0
//                            middleView.removeFromSuperview()
//                            transitionContext.completeTransition(success)
//                        })
//                } else {
//
//                    guard let fromVC = transitionContext.viewController(forKey: .from) as? AddWorkoutViewController else { fatalError() }
//                    guard let toVC = transitionContext.viewController(forKey: .to)?.children.first?.children.last as? WorkoutViewController else {fatalError()}
//                    let fromView = fromVC.contentView
//                    let toView = toVC.addWorkoutCardView
//                    toView.alpha = 0.0
//                    fromView.alpha = 0.0
////                    toView.frame = containerView.frame
//
//
//                    containerView.addSubview(toView)
//                    toView.layoutIfNeeded()
//                    let startFrame = fromView.frame
//                    let finalFrame = toView.frame
//
//                    let middleView = CardView(frame: startFrame)
//                    middleView.part = .top
//                    middleView.clipsToBounds = true
//                    middleView.layer.masksToBounds = true
//                    middleView.contentMode = .scaleAspectFill
//                    containerView.addSubview(middleView)
//
//
//                    UIView.animate(withDuration: duration, animations: {
//                        middleView.frame = finalFrame
//
//                    }, completion: { finished in
//                        let success = !transitionContext.transitionWasCancelled
//
//                        toVC.addWorkoutCardView.isHidden = false
//                        toVC.addWorkoutCardView.layoutIfNeeded()
//                        toView.alpha = 1.0
//                        middleView.alpha = 0.0
//                        middleView.removeFromSuperview()
//                        transitionContext.completeTransition(success)
//                    })
//                }
//    }
//
//}
//
