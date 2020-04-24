//
//  WorkoutVolumeChartView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/24.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import Charts

class WorkoutVolumeChartView: BaseCardView {
    // MARK: Model
    
    var workoutName: String = "" {
        didSet {
            workoutDidChanged()
        }
    }
    
    
    // MARK: View
    
    fileprivate var lineChartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChartView()
        updateChartWithData()
    }
    
    fileprivate func setupChartView() {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .clear
        
        addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(10)
        }
        
        self.lineChartView = lineChartView
    }
    
    fileprivate func updateChartWithData() {
//
//
//
//        let values = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
//        }
//
//        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
//        set1.drawIconsEnabled = false
//
//        set1.lineDashLengths = [5, 2.5]
//        set1.highlightLineDashLengths = [5, 2.5]
//        set1.setColor(.black)
//        set1.setCircleColor(.black)
//        set1.lineWidth = 1
//        set1.circleRadius = 3
//        set1.drawCircleHoleEnabled = false
//        set1.valueFont = .systemFont(ofSize: 9)
//        set1.formLineDashLengths = [5, 2.5]
//        set1.formLineWidth = 1
//        set1.formSize = 15
//
//        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//        set1.fillAlpha = 1
//        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//        set1.drawFilledEnabled = true
//
//        let data = LineChartData(dataSet: set1)
//
//        chartView.data = data
    }
    
    func animateChart() {
    }
    
    func workoutDidChanged() {
        lineChartView.setNeedsDisplay()
    }
}
