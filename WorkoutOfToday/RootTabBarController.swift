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
        
        let todayWorkoutViewController = TodayWorkoutViewController()
        let feedViewController = FeedViewController()
        let settingViewController = UINavigationController(rootViewController: SettingTableViewController(style: .grouped))
        let tabBarControllers = [todayWorkoutViewController, feedViewController, settingViewController]
        self.viewControllers = tabBarControllers
        
        if let items = self.tabBar.items {
            items[0].title = "오늘의 운동"
            items[1].title = "피드"
            items[2].title = "설정"
        }
    }
}
