//
//  UITableView+Register.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        self.register(T.self,
                      forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type,
                                                 for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self),
                                            for: indexPath) as! T
        return cell
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(T.self,
                      forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type,
                                                      for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                            for: indexPath) as! T
        return cell
    }
    
    func registerForHeaderView<T: UICollectionReusableView>(_ cellClass: T.Type) {
        self.register(T.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableSupplementaryHeaderView<T: UICollectionReusableView>(_ class: T.Type, for indexPath: IndexPath) -> T {
        let reusableView = self
            .dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: T.self),
                for: indexPath) as! T
        
        return reusableView
    }
}
