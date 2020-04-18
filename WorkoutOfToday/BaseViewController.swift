//
//  BaseViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/18.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

// MARK: Base ViewController for all of the controllers

class BaseViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setup() {
        // setup subViews and layout
    }
    
    public func showBasicAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    public func showActionSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    public func addObserverToNotificationCenter(_ NotificationName: NSNotification.Name, selector aSelector: Selector) {
        NotificationCenter.default.addObserver(self,
                                               selector: aSelector,
                                               name: NotificationName,
                                               object: nil)
    }
    
    public func postNotification(_ NotificationName: NSNotification.Name) {
        NotificationCenter.default .post(name: NotificationName, object: nil)
    }
}



// MARK: ModalDidDismissedNotification

extension NSNotification.Name {
    static let WorkoutDidModifiedNotification = NSNotification.Name(rawValue: "WorkoutDidModifiedNotification")
}
