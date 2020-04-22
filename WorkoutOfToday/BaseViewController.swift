//
//  BaseViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/18.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

// MARK: Base ViewController for all of the controllers

class BaseViewController: UIViewController {
    
    public var token: NotificationToken? = nil
    
    public var navigationBarTitle: String {
        return ""
    }
    
    override func loadView() {
        super.loadView()
        setup()
        configureNavigationBar()
    }
    
    public func setup() {
        // setup subViews and layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .defaultBackgroundColor
        
    }
    
    public func configureNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            title = self.navigationBarTitle
        }

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

// MARK: Width for string

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
