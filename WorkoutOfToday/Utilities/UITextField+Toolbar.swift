//
//  UITextField+Toolbar.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/09.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UITextField {
    func addToolbar(onDone: (target: Any, title: String, action: Selector)? = nil, onCancel: (target: Any, title: String, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, title: "취소", action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, title: "확인", action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: onCancel.title, style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: onDone.title, style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
    }
}

