//
//  BaseViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/18.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

// MARK: Basic ViewController for all of the controllers

class BasicViewController: UIViewController {
    
    public var keyboardNotificationTokens = [BasicNotificationToken]()
    
    public var notificationTokens = [BasicNotificationToken]()
    
    public var workoutDidAddedNotificationToken: BasicNotificationToken?
    
    public var workoutDidDeletedNotificationToken: BasicNotificationToken?
    
    public var moved: CGFloat?
    
    public var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    public var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    public var navigationBarTitle: String {
        return ""
    }
    
    override func loadView() {
        super.loadView()
        setup()
        setupFeedbackGenerator()
        configureNavigationBar()
    }
    
    public func setup() {}
    
    public func setupFeedbackGenerator() {}
    
    public func configureNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            title = self.navigationBarTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        registerNotifications()
        view.backgroundColor = .defaultBackgroundColor
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    public func registerNotification(_ NotificationName: NSNotification.Name, using block: @escaping (Notification) -> ()) {
        let token = NotificationCenter.default.addObserver(forName: NotificationName, object: nil, queue: OperationQueue.main, using: block)
        let notificationToken = BasicNotificationToken(token: token, center: .default)
        notificationTokens.append(notificationToken)
    }
    
    public func registerNotifications() {}
    
    public func postNotification(_ NotificationName: NSNotification.Name) {
        NotificationCenter.default.post(name: NotificationName, object: nil)
    }
    
    // MARK: Notification for Keyboard
    
    private func registerKeyboardNotifications() {
        let keyboardWillShow = NotificationCenter.default.addObserver(with: UIViewController.keyboardWillShow) { [weak self] payload in
            guard let strongSelf = self else { return }
            let bounds = payload.finalFrame
            strongSelf.keyboardWillShow(in: bounds)
        }
        let keyboardWillHide = NotificationCenter.default.addObserver(with: UIViewController.keyboardWillHide) { [weak self] payload in
            guard let strongSelf = self else { return }
            strongSelf.keyboardWillHide()
        }
        
        keyboardNotificationTokens.append(contentsOf: [keyboardWillShow, keyboardWillHide])
    }
    
    public func keyboardWillShow(in bounds: CGRect?) {}
    
    public func keyboardWillHide() {}
    
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
    
}
