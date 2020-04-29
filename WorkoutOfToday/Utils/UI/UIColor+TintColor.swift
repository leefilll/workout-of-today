//
//  UIColor+TintColor.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(displayP3Red: CGFloat(r / 255.0),
                       green: CGFloat(g / 255.0),
                       blue: CGFloat(b / 255.0),
                       alpha: CGFloat(alpha))
    }

    static var tintColor = UIColor.colorWithRGBHex(hex: 0x6C91F3)
    
    static var weakTintColor = UIColor.colorWithRGBHex(hex: 0xe2e9fd)
    
    static var defaultBackgroundColor = UIColor.groupTableViewBackground
    
    static var concaveColor = UIColor.colorWithRGBHex(hex: 0xe5e6e8).withAlphaComponent(0.5)
        
    static func part(_ part: Part) -> UIColor {
        switch part {
            case .none: return UIColor.lightGray
            case .chest: return UIColor.colorWithRGBHex(hex: 0xED5565)
            case .shoulder: return UIColor.colorWithRGBHex(hex: 0xAC92EC)
            case .back: return UIColor.colorWithRGBHex(hex: 0xFFCE54)
            case .legs: return UIColor.colorWithRGBHex(hex: 0xA0D468)
            case .arms: return UIColor.colorWithRGBHex(hex: 0x48CFAD)
            case .core: return UIColor.colorWithRGBHex(hex: 0x4FC1E9)
            case .cardio: return UIColor.colorWithRGBHex(hex: 0x5D9CEC)
            case .body: return UIColor.colorWithRGBHex(hex: 0xF09A37)
        }
    }
}
