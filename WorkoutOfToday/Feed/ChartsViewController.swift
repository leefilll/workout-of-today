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

class ChartsViewController: BaseViewController, Childable {
    
    // MARK: Model
    
    var workoutsOfDays: Results<WorkoutsOfDay>!
    
    // MARK: View
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    weak var scrollView: UIScrollView!
    
//    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var workoutPartLabel: UILabel!
    
    @IBOutlet weak var partChartView: WorkoutPartChartView!
    
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var volumeChartView: WorkoutVolumeChartView!
    
    @IBOutlet weak var onermChartView: WorkoutOnermChartView!
    
    @IBOutlet weak var workoutLabel: UILabel!
    
    @IBOutlet weak var workoutSelectButton: BaseButton!
    
    override func setup() {
        setupLabels()
        setupButton()
        setupSegmentedControl()
    }
    
    fileprivate func setupLabels() {
        workoutPartLabel.text = "종목별"
        workoutLabel.text = "운동별"
        
        workoutPartLabel.font = .smallBoldTitle
        workoutLabel.font = .smallBoldTitle
    }
    
    fileprivate func setupButton() {
        workoutSelectButton.setTitle("운동 선택", for: .normal)
        workoutSelectButton.backgroundColor = .tintColor
        workoutSelectButton.setTitleColor(.white, for: .normal)
    }
    
    fileprivate func setupSegmentedControl() {
        periodSegmentedControl.setTitle("한달", forSegmentAt: 0)
        periodSegmentedControl.setTitle("두달", forSegmentAt: 1)
        periodSegmentedControl.setTitle("전체", forSegmentAt: 2)
        
        periodSegmentedControl.selectedSegmentIndex = 0
        periodSegmentedControl.layer.cornerRadius = 5.0
        periodSegmentedControl.backgroundColor = .weakTintColor
        periodSegmentedControl.setBackgroundColor(.tintColor, for: .selected)
        periodSegmentedControl.tintColor = .tintColor
        periodSegmentedControl.addTarget(self, action: #selector(selectionDidChanged(_:)), for: .valueChanged)
        
        // TODO: change to all versions
        if #available(iOS 13.0, *) {
            periodSegmentedControl.selectedSegmentTintColor = .tintColor
            periodSegmentedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ],
                for: .selected
            )
            periodSegmentedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.tintColor,
                    NSAttributedString.Key.font: UIFont.subheadline
                ],
                for: .normal
            )
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCharts()
    }
    
    fileprivate func animateCharts() {
        partChartView.animateChart()
    }
}

// MARK: objc functions

extension ChartsViewController {
    @objc
    func selectionDidChanged(_ sender: UISegmentedControl) {
        
    }
}

