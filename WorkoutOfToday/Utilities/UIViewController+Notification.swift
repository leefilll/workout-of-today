//
//  UIViewController+Notification.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIViewController {
    func addObserverToNotificationCenter(_ NotificationName: NSNotification.Name, selector aSelector: Selector) {
           NotificationCenter
               .default
               .addObserver(self,
                            selector: aSelector,
                            name: NotificationName,
                            object: nil)
       }
    
    func postNotification(_ NotificationName: NSNotification.Name) {
        NotificationCenter
            .default
            .post(name: NotificationName, object: nil)
    }
 
}


// MARK: ModalDidDismissedNotification

extension NSNotification.Name {
    static let WorkoutDidAddedNotification = NSNotification.Name(rawValue: "WorkoutDidAddedNotification")
    static let WorkoutDidModifiedNotification = NSNotification.Name(rawValue: "WorkoutDidModifiedNotification")
}
