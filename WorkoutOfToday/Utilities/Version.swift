//
//  Version.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

class Version {
    static var version: String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let version = infoDictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    static var build: String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let build = infoDictionary["CFBundleVersion"] as? String else { return "" }
        return build
    }
}
