//
//  SlideTransitioningDelegate.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class SlideTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate var heightRatio: CGFloat
    
    init(heightRatio: CGFloat) {
        self.heightRatio = heightRatio
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SlidePresentationController(presentedViewController: presented, presenting: presenting, heighRatio: heightRatio)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(animationDuration: 0.25, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(animationDuration: 0.25, animationType: .dismiss)
    }
}

