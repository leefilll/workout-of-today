//
//  RootTabBarController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var workoutsOfDay: WorkoutsOfDay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .tintColor
        delegate = self
        
        let keyFromDate = DateFormatter.shared.keyStringFromDate
        if let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self,
                                                            forPrimaryKey: keyFromDate) {
            self.workoutsOfDay = workoutsOfDay
        } else {
            let newWorkoutsOfDay = WorkoutsOfDay()
            self.workoutsOfDay = newWorkoutsOfDay
            
            DBHandler.shared.create(object: newWorkoutsOfDay)
        }
        
        let profileNavigationController = UINavigationController(rootViewController: ProfileViewController())
        
        let todayWorkoutViewController = TodayWorkoutViewController()
        todayWorkoutViewController.workoutsOfDay = self.workoutsOfDay
        let todayWorkoutNavigationController = UINavigationController(rootViewController: todayWorkoutViewController)
        
        let feedViewController = UINavigationController(rootViewController: FeedMasterViewController())
        
        
        let tabBarControllers = [profileNavigationController,
                                 todayWorkoutNavigationController,
                                 feedViewController]
        self.viewControllers = tabBarControllers
        
        if let items = self.tabBar.items {
            items[0].title = "프로필"
            items[1].title = "오늘의 운동"
            items[2].title = "이력"
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        if viewController == tabBarController.viewControllers?[1] {
//            let vc = WorkoutAddViewController()
//            vc.workoutsOfDayId = self.workoutsOfDay.id
//            DispatchQueue.main.async {
//                self.present(vc, animated: true, completion: nil)
//            }
//
//            return false
//        }
        return true
    }
}
