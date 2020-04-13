//
//  UIFont+Static.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/09.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIFont {
    static var veryLargeTitle: UIFont {
        let fontSize: CGFloat = 60
        return UIFont(name: "AppleSDGothicNeo-Medium", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var largeTitle: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let fontSize = font.pointSize
//        return UIFont.boldSystemFont(ofSize: fontSize)
        return UIFont(name: "AppleSDGothicNeo-SemiBold", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var title: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .title1)
        let fontSize = font.pointSize
        return UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var boldTitle: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .title2)
        let fontSize = font.pointSize
        return UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var body: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontSize = font.pointSize
        return UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var boldBody: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontSize = font.pointSize
        return UIFont(name: "AppleSDGothicNeo-Medium", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var lightDescription: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        let fontSize = font.pointSize
//        return UIFont(name: "Helvetica-Light", size: fontSize) ??
            return UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    
    static var subheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    static var description: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption1)
    }
}
