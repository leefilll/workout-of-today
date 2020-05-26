//
//  HighlightsWeekChartView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/12.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import Charts

final class HighlightsWeekChartView: BasicChartView {
    
    // MARK: View
    
    private var barChartView: BarChartView!
    
    // MARK: Model
    
    private var xAxisFormatter: IAxisValueFormatter?
    
    private var yAxisFormatter: IAxisValueFormatter?
    
    private var valueFormatter: IValueFormatter?
    
    private var maxValue: Double = 0.0
    
    private var weekdaysCount: [Int]?
    
    override var subtitle: String? {
        return "요일별 운동 횟수"
    }
    
    enum WeekDays: CaseIterable {
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
    }
    
    override func setup() {
        super.setup()
        setupModel()
        setupChartView()
        updateChartWithData()
    }
    
    private func setupModel() {
        let weekdaysCount = DBHandler.shared.fetchWorkoutsOfDaysByWeekDays()
        if !isEmpty(weekdaysCount) {
            self.weekdaysCount = weekdaysCount
            isEmpty = false
        }
    }
    
    private func setupChartView() {
        let barChartView = BarChartView()
        barChartView.backgroundColor = .clear
        chartContainerView.addSubview(barChartView)
        barChartView.snp.makeConstraints { make in
            make.bottom.leading.trailing.top.equalToSuperview()
        }
        xAxisFormatter = self
        yAxisFormatter = self
        valueFormatter = self
        self.barChartView = barChartView
    }
    
    // MARK: Check weekdaysCount is Empty or not
    private func isEmpty(_ array: [Int]) -> Bool {
        for elem in array {
            if elem != 0 {
                return false
            }
        }
        return true
    }
    
    private func updateChartWithData() {
        guard let weekdaysCount = weekdaysCount else {
            isEmpty = true
            return
        }
        
        let dataEntries = weekdaysCount.enumerated().map { idx, val -> BarChartDataEntry in
            let xVal = Double(idx)
            var yVal: Double
            if (val == 0) {
                yVal = 0.01
            } else {
                yVal = Double(val)
            }
            return BarChartDataEntry(x: xVal, y: yVal)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries)
        dataSet.drawValuesEnabled = false
        dataSet.setColor(.tintColor)
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFormatter(valueFormatter!)
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.gridLineWidth = 0
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = xAxisFormatter
        
        maxValue = Double(weekdaysCount.max() ?? 0)
        let upperLimitLine = ChartLimitLine(limit: maxValue)
        upperLimitLine.lineWidth = 2
        upperLimitLine.lineDashLengths = [5, 5]
        upperLimitLine.lineColor = .weakTintColor

        let rightAxis = barChartView.rightAxis
        rightAxis.removeAllLimitLines()
        rightAxis.addLimitLine(upperLimitLine)
        rightAxis.axisMaximum = maxValue
        rightAxis.drawLimitLinesBehindDataEnabled = true
        rightAxis.axisLineColor = .clear
        rightAxis.labelFont = .description
        rightAxis.labelTextColor = .lightGray
        rightAxis.gridColor = .clear
        rightAxis.drawLimitLinesBehindDataEnabled = true
        rightAxis.valueFormatter = yAxisFormatter
        
        barChartView.data = data
        barChartView.dragEnabled = false
        barChartView.highlightValue(nil)
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.legend.enabled = false
        barChartView.chartDescription?.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = true
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.highlightPerTapEnabled = false
        barChartView.setScaleEnabled(false)
    }
    
    func animateChart() {
        barChartView.animate(yAxisDuration: 0.5)
    }
}

// MARK: Value Formatter Delegate

extension HighlightsWeekChartView: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}

// MARK: Axis Formatter Delegate

extension HighlightsWeekChartView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let axis = axis else { return "" }
        if axis == barChartView.xAxis {
            let index = Int(value)
            guard let weekdaySymbol = DateFormatter.shared.shortWeekdaySymbols?[index] else {
                return ""
            }
            return weekdaySymbol
        } else {
            if value == maxValue {
                return "\(Int(value))회"
            }
            return ""
        }
    }
}
