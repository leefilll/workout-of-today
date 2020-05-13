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
    
    fileprivate var volumesByDate: [(date: Date, volume: Double)]?
    
    fileprivate var valueFormatter: IValueFormatter?
    
    fileprivate var xAxisFormatter: IAxisValueFormatter?
    
    var workoutName: String = "데드리프트" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var period: Period = .oneMonth {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: View
    
    fileprivate var lineChartView: LineChartView!
    
    override func setup() {
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
            make.top.equalToSuperview().offset(10)
        }
        valueFormatter = self
        xAxisFormatter = self
        lineChartView.delegate = self
        
        self.lineChartView = lineChartView
    }
    
    fileprivate func updateChartWithData() {
        volumesByDate = DBHandler.shared.fechWorkoutVolumeByPeriod(workoutName: workoutName, period: period)
        guard let volumesByDate = volumesByDate else { fatalError() }
        
        // MARK: note that x value used for index
        let entries = volumesByDate.enumerated().map { idx, value -> ChartDataEntry in
            let volume = value.volume
            return ChartDataEntry(x: Double(idx), y: Double(volume))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.drawIconsEnabled = false
        set.highlightLineDashLengths = [5, 2.5]
        set.setColor(.tintColor)
        set.setCircleColor(.tintColor)
        set.circleHoleColor = .weakTintColor
        set.lineWidth = 2
        set.circleRadius = 4
        set.circleHoleRadius = 2
        set.drawCircleHoleEnabled = true
        set.valueFont = .subheadline
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 1
        set.formSize = 15
        set.drawFilledEnabled = false
        
        let data = LineChartData(dataSet: set)
        data.setValueFormatter(valueFormatter!)
        
        lineChartView.data = data
        lineChartView.chartDescription?.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.extraRightOffset = 30
        lineChartView.extraLeftOffset = 30
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.gridLineWidth = 0
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 2
        xAxis.labelCount = 7
        xAxis.valueFormatter = xAxisFormatter
    }
    
    func animateChart() {
        lineChartView.animate(xAxisDuration: 0.8)
    }
    
}

// MARK: ChartView Delegate

extension WorkoutVolumeChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}

// MARK: Value Formatter Delegate

extension WorkoutVolumeChartView: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
        //        if value == 0 {
        //            return ""
        //        }
        //
        //        let pFormatter = NumberFormatter()
        //        pFormatter.numberStyle = .none
        //        pFormatter.multiplier = 1
        //
        //        guard let formattedString = pFormatter.string(from: NSNumber(value: value)) else {
        //            return ""
        //        }
        //        return formattedString + " kg"
    }
}

// MARK: Axis Formatter Delegate

extension WorkoutVolumeChartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let volumesByDate = volumesByDate else { return "" }
        let date = volumesByDate[Int(value)].date
        
        let formatter = DateFormatter.shared
        formatter.setLocalizedDateFormatFromTemplate("MMMM-d")
        let dateString = formatter.string(from: date)
        return dateString
    }
}
