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

    static var tintColor = UIColor.colorWithRGBHex(hex: 0x507df6)
    
    static var concaveColor = UIColor.colorWithRGBHex(hex: 0xe5e6e8).withAlphaComponent(0.5)
    
    enum PartColor: Int {
        case none = 0
        case chest
        case shoulder
        case back
        case legs
        case arms
        case abdominal
        case cardio
    }
    
    class func partColor(_ rawValue: Int) -> UIColor {
        switch rawValue {
//            case 0: return UIColor.colorWithRGBHex(hex: 0xC4C4C4)
            case 0: return UIColor.lightGray
//            case 1: return UIColor.colorWithRGBHex(hex: 0xE75A2B)
//            case 2: return UIColor.colorWithRGBHex(hex: 0xF7CC45)
//            case 3: return UIColor.colorWithRGBHex(hex: 0x87D05E)
//            case 4: return UIColor.colorWithRGBHex(hex: 0x5DA7EF)
//            case 5: return UIColor.colorWithRGBHex(hex: 0x73D2E6)
//            case 6: return UIColor.colorWithRGBHex(hex: 0xF09A37)
//            case 1: return UIColor.colorWithRGBHex(hex: 0xda6e6a)
//            case 2: return UIColor.colorWithRGBHex(hex: 0x749af7)
//            case 3: return UIColor.colorWithRGBHex(hex: 0x7d60f5)
//            case 4: return UIColor.colorWithRGBHex(hex: 0xea9945)
//            case 5: return UIColor.colorWithRGBHex(hex: 0x5aa764)
//            case 6: return UIColor.colorWithRGBHex(hex: 0x294eca)
//            case 7: return UIColor.colorWithRGBHex(hex: 0x000000)
            case 1: return UIColor.colorWithRGBHex(hex: 0xED5565)
            case 2: return UIColor.colorWithRGBHex(hex: 0xAC92EC)
            case 3: return UIColor.colorWithRGBHex(hex: 0xFFCE54)
            case 4: return UIColor.colorWithRGBHex(hex: 0xA0D468)
            case 5: return UIColor.colorWithRGBHex(hex: 0x48CFAD)
            case 6: return UIColor.colorWithRGBHex(hex: 0x4FC1E9)
            case 7: return UIColor.colorWithRGBHex(hex: 0x5D9CEC)
            default: return .lightGray
        }
    }
}


/*
 
 0xAC92EC
 0xEC87C0
 
 
 
 */
