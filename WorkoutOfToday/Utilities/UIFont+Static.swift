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
        let font = UIFont.boldSystemFont(ofSize: 35)
        return font
    }
    
    static var largeTitle: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let fontSize = font.pointSize
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var title: UIFont {
        let font = UIFont.preferredFont(forTextStyle: .title2)
        let fontSize = font.pointSize
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    static var body: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static var subheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    static var description: UIFont {
        
        return UIFont.preferredFont(forTextStyle: .caption1)
    }
}
