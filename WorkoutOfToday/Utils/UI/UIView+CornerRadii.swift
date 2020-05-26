//
//  UIView+CornerRadii.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIView {
    func configureRoundedRect(usingRadius radius: CGFloat) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    func configureRoundedRect(withCorners corners: UIRectCorner, usingRadii radii: CGFloat) {
        let roundedRectWithCorners = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radii, height: radii))
        roundedRectWithCorners.addClip()
        UIColor.white.setFill()
        roundedRectWithCorners.fill()
    }
    
    func setRoundedCorners(corners: UIRectCorner, radius: CGFloat) {
          let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
          let mask = CAShapeLayer()
          mask.path = path.cgPath
          layer.mask = mask
      }
}

private enum PartOfView {
    case top
    case bottom
    case entire
    case middle
}
