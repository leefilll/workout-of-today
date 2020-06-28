//
//  RootTabBarController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
//    private var workoutsOfDay: WorkoutsOfDay?
    private weak var profileViewController: ProfileViewController!
    
    private weak var todayWorkoutViewController: TodayWorkoutViewController!
    
    private weak var feedViewController: FeedMasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        tabBar.tintColor = .tintColor
        delegate = self
        
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        let todayWorkoutViewController = TodayWorkoutViewController()
        let todayWorkoutNavigationController = UINavigationController(rootViewController: todayWorkoutViewController)
        
        let feedViewController = FeedMasterViewController()
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        
        viewControllers = [profileNavigationController,
                           todayWorkoutNavigationController,
                           feedNavigationController]
        
        selectedIndex = 1
        
        if let items = tabBar.items {
            items[0].title = "프로필"
            items[0].image = UIImage(named: "Profile")
            items[1].title = "오늘의 운동"
            items[1].image = UIImage(named: "Workout")
            items[2].title = "이력"
            items[2].image = UIImage(named: "History")
        }
        self.profileViewController = profileViewController
        self.todayWorkoutViewController = todayWorkoutViewController
        self.feedViewController = feedViewController
    }
}
