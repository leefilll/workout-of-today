//
//  NotificationToken.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/02.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

final class BasicNotificationToken {
    let token: NSObjectProtocol
    let center: NotificationCenter
    
    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    
    deinit {
        center.removeObserver(token)
    }
}

extension NotificationCenter {
    func addObserver<T> (
        with descriptor: NotificationDescriptor<T>,
        using block: @escaping (T) -> ()) -> BasicNotificationToken {
        let token = addObserver(forName: descriptor.name, object: nil, queue: nil) { noti in
            block(descriptor.convert(noti))
        }
        return BasicNotificationToken(token: token, center: self)
    }
}


extension NSNotification.Name {
    static let WorkoutDidAddedAtFirst = NSNotification.Name(rawValue: "WorkoutDidAddedAtFirst")
    
    static let WorkoutDidDeleted = NSNotification.Name(rawValue: "WorkoutDidDeleted")
    
    static let WorkoutDidAdded = NSNotification.Name(rawValue: "WorkoutDidAdded")
}
