//
//  RootTabBarController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var workoutsOfDay: WorkoutsOfDay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        tabBar.tintColor = .tintColor
        delegate = self
        
        let keyFromDate = DateFormatter.shared.keyStringFromNow
        if let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self,
                                                            forPrimaryKey: keyFromDate) {
            self.workoutsOfDay = workoutsOfDay
        }
        
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let todayWorkoutViewController = TodayWorkoutViewController()
        todayWorkoutViewController.workoutsOfDay = workoutsOfDay
        let todayWorkoutNavigationController = UINavigationController(rootViewController: todayWorkoutViewController)
        
        let feedViewController = UINavigationController(rootViewController: FeedMasterViewController())
        
        
        let tabBarControllers = [profileNavigationController,
                                 todayWorkoutNavigationController,
                                 feedViewController]
        viewControllers = tabBarControllers
        selectedIndex = 1
        
        if let items = tabBar.items {
            items[0].title = "프로필"
            items[1].title = "오늘의 운동"
            items[2].title = "이력"
        }
    }
}
