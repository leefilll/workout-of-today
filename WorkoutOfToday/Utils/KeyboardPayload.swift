//
//  KeyboardPayload.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/02.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

struct KeyboardPayload {
    let beginFrame: CGRect
    let finalFrame: CGRect
}

extension KeyboardPayload {
    init(notification: Notification) {
        let userInfo = notification.userInfo
        beginFrame = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        finalFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    }
}

extension UIViewController {
    static let keyboardWillShow = NotificationDescriptor(
        name: UIResponder.keyboardWillShowNotification,
        convert: KeyboardPayload.init)
    static let keyboardWillHide = NotificationDescriptor(
        name: UIResponder.keyboardWillHideNotification,
        convert: KeyboardPayload.init)
}
