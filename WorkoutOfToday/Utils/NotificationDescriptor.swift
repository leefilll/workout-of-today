//
//  NotificationDescriptor.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/02.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

struct NotificationDescriptor<T> {
    let name: NSNotification.Name
    let convert: (Notification) -> T
}
