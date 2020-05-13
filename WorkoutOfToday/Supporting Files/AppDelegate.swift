//
//  AppDelegate.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/07.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            return true
        } else {
            window = UIWindow()
            window?.rootViewController = RootTabBarController()
            window?.makeKeyAndVisible()
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let keyFromDate = DateFormatter.shared.keyStringFromNow
        guard let workoutsOfDay = DBHandler.shared.fetchObject(ofType: WorkoutsOfDay.self,
                                                                forPrimaryKey: keyFromDate) else { return }
        if workoutsOfDay.numberOfWorkouts == 0 {
            DBHandler.shared.deleteWorkoutsOfDay(workoutsOfDay: workoutsOfDay)
            print("Empty Workout was deleted")
        }
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}


