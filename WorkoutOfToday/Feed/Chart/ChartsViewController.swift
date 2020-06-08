//
//  ChartsViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import Charts

final class ChartsViewController: BasicViewController {
    
    // MARK: Model
    
//    var workoutsOfDays: Results<WorkoutsOfDay>!
    
    // MARK: View
    
    @IBOutlet weak var workoutPartLabel: UILabel!
    
    @IBOutlet weak var partChartView: WorkoutPartChartView!
    
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var volumeChartView: WorkoutVolumeChartView!
    
    @IBOutlet weak var workoutLabel: UILabel!
    
    @IBOutlet weak var workoutSelectButton: BasicButton!
    
    override func setup() {
        setupLabels()
        setupButton()
    }
    
    private func setupLabels() {
        workoutPartLabel.text = "종목별"
        workoutLabel.text = "운동별"
        
        workoutPartLabel.font = .smallBoldTitle
        workoutLabel.font = .smallBoldTitle
    }
    
    private func setupButton() {
        workoutSelectButton.setTitle("운동 선택", for: .normal)
        workoutSelectButton.backgroundColor = .tintColor
        workoutSelectButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: Version 2.0
//    private func setupSegmentedControl() {
//        periodSegmentedControl.setTitle(Period.oneMonth.description, forSegmentAt: 0)
//        periodSegmentedControl.setTitle(Period.threeMonths.description, forSegmentAt: 1)
//        periodSegmentedControl.setTitle(Period.entire.description, forSegmentAt: 2)
//
//        periodSegmentedControl.selectedSegmentIndex = 0
//        periodSegmentedControl.layer.cornerRadius = 5.0
//        periodSegmentedControl.backgroundColor = .weakTintColor
//        periodSegmentedControl.setBackgroundColor(.tintColor, for: .selected)
//        periodSegmentedControl.tintColor = .tintColor
//        periodSegmentedControl.addTarget(self, action: #selector(selectionDidChanged(_:)), for: .valueChanged)
//
//        periodSegmentedControl.backgroundColor = .white
//        periodSegmentedControl.tintColor = .weakTintColor
//        periodSegmentedControl.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.foregroundColor: UIColor.tintColor,
//                NSAttributedString.Key.font: UIFont.subheadline,
//            ],
//            for: .selected
//        )
//        periodSegmentedControl.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
//                NSAttributedString.Key.font: UIFont.subheadline,
//            ],
//            for: .normal
//        )
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCharts()
    }
    
    private func animateCharts() {
        partChartView.animateChart()
        volumeChartView.animateChart()
    }
}

// MARK: objc functions

extension ChartsViewController {
    @objc
    func selectionDidChanged(_ sender: UISegmentedControl) {
        guard let period = Period(rawValue: sender.selectedSegmentIndex) else { fatalError() }
        volumeChartView.period = period
    }
}

// MARK: enum - Period

enum Period: Int, CustomStringConvertible {
    case oneMonth
    case threeMonths
    case entire
    
    var description: String {
        switch self {
            case .oneMonth: return "한달"
            case .threeMonths: return "세달"
            case .entire: return "전체"
        }
    }
}


