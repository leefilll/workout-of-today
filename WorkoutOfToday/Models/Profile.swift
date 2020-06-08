//
//  Profile.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RealmSwift

final class Profile: Object {
    @objc dynamic var created: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var height: Double = 0
    @objc dynamic var muscleWeight: Double = 0
    @objc dynamic var fatPercentage: Double = 0
    
    private let weights = List<Double>()
    
    func addNewWeight(_ newWeight: Double) {
        weights.append(newWeight)
    }
    
    func getRecentWeight() -> Double {
        return weights.last ?? 0.0
    }
    
    private func calculateBMI() -> Double {
        let weight = getRecentWeight()
        let heightPerMeter = height / 100
        let bmi = weight / (heightPerMeter * heightPerMeter)
        return bmi
    }
    
    func getBMI() -> (Double, String) {
        let bmiIndex = calculateBMI()
        let bmi = BMI.checkBmi(bmiIndex)
        return (bmiIndex, bmi.string)
    }
    
    private enum BMI {
        case lowweight
        case regular
        case overweight
        case obesity
        case extremelyObesity
        
        static func checkBmi(_ bmi: Double) -> BMI {
            if bmi <= 18.5 {
                // 저체중
                return .lowweight
            } else if bmi <= 23 {
                // 정싱
                return .regular
            } else if bmi <= 25 {
                // 과체중
                return .overweight
            } else if bmi <= 30 {
                // 비만
                return .obesity
            } else {
                // 고도 비만
                return .extremelyObesity
            }
        }
        
        var string: String {
            switch self {
                case .lowweight: return "저체중"
                case .regular: return "정상 체중"
                case .overweight: return "과체중"
                case .obesity: return "비만"
                case .extremelyObesity: return "고도 비만"
            }
        }
    }
}
