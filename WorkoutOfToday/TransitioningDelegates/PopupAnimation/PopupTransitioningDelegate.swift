//
//  PopupTransitioningDelegate.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class PopupTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var widthRatio: CGFloat = 0
    
    private var heightRatio: CGFloat = 0
    
    private var height: CGFloat = 0
    
    private var minY: CGFloat? = nil
    
    init(widthRatio: CGFloat, heightRatio: CGFloat, minY: CGFloat? = nil) {
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.minY = minY
    }
    
    init(height: CGFloat) {
        self.height = height
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if height == 0 {
            return PopupPresentationController(presentedViewController: presented, presenting: presenting, widthRatio: widthRatio, heighRatio: heightRatio, minY: minY)
        } else {
            return PopupPresentationController(presentedViewController: presented, presenting: presenting, height: height)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(animationDuration: 0.15, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopupAnimator(animationDuration: 0.15, animationType: .dismiss)
    }
}
