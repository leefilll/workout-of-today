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
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let fontSize = font.pointSize + CGFloat(15)
        return UIFont(name: "AppleSDGothicNeo-SemiBold", size: fontSize) ??
            UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    static var largeTitle: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let fontSize = font.pointSize
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
        let font = UIFont.preferredFont(forTextStyle: .title1)
        let fontSize = font.pointSize
        return UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var smallBoldTitle: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .title2)
        let fontSize = font.pointSize
        return UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize) ??
//            UIFont.systemFont(ofSize: fontSize, weight: .regular)
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
        return UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize) ??
            UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var subheadline: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        let fontSize = font.pointSize
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var description: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption1)
    }
}
