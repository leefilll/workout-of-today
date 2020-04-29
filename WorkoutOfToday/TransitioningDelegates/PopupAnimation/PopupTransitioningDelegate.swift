//
//  PopupTransitioningDelegate.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class PopupTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate var widthRatio: CGFloat
    
    fileprivate var heightRatio: CGFloat
    
    fileprivate var minY: CGFloat? = nil
    
    init(widthRatio: CGFloat, heightRatio: CGFloat, minY: CGFloat? = nil) {
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.minY = minY
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopupPresentationController(presentedViewController: presented, presenting: presenting, widthRatio: widthRatio, heighRatio: heightRatio, minY: minY)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(animationDuration: 0.15, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(animationDuration: 0.15, animationType: .dismiss)
    }
}
