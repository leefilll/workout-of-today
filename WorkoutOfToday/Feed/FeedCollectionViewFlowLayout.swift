//
//  FeedCollectionViewFlowLayout.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/16.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let cellSpacing: CGFloat = 5
//
//    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attribute = super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
//        return attribute!
//    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 8.0
        self.sectionInset = UIEdgeInsets(top:0, left: 15, bottom: 0, right: 15)
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        for attribute in attributes! {
//            let decoratedAttributes = FeedCollectionViewLayoutAttributes(forSupplementaryViewOfKind: "sectionBackground", with: attribute.indexPath)
            let itemAttributesCopy = attribute.copy() as! UICollectionViewLayoutAttributes
            attributesCopy.append(itemAttributesCopy)
        }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributesCopy.forEach { layoutAttribute in
            if layoutAttribute.representedElementKind ==
                UICollectionView.elementKindSectionHeader {
                return
            }

            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributesCopy
    }
}
