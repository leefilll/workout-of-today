//
//  FeedCollectionViewFlowLayout.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/16.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    init(minimumInteritemSpacing: CGFloat, minimumLineSpacing: CGFloat, sectionInset: UIEdgeInsets) {
        super.init()
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        for attribute in attributes! {
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
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributesCopy
    }
}
