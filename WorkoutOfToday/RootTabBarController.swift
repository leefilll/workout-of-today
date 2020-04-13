//
//  RootTabBarController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let todayWorkoutViewController = UINavigationController(rootViewController: TodayWorkoutViewController())
        let addWorkoutViewController = WorkoutAddViewController()
        let feedViewController = UINavigationController(rootViewController: FeedViewController())
        let tabBarControllers = [todayWorkoutViewController, addWorkoutViewController, feedViewController]
        self.viewControllers = tabBarControllers
        
        
        if let items = self.tabBar.items {
            items[0].title = "오늘의 운동"
            items[1].title = "운동 추가"
            items[2].title = "이력"
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is WorkoutAddViewController {
            let vc = WorkoutAddViewController()
            self.modalPresentationStyle = .currentContext
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
}
