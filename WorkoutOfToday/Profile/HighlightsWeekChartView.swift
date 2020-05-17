//
//  HighlightsWeekChartView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/12.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import Charts

final class HighlightsWeekChartView: HighlightsView {
    
    // MARK: View
    
    fileprivate var barChartView: BarChartView!
    
    // MARK: Model
    
    fileprivate var xAxisFormatter: IAxisValueFormatter?
    
    fileprivate var yAxisFormatter: IAxisValueFormatter?
    
    fileprivate var valueFormatter: IValueFormatter?
    
    fileprivate var maxValue: Double = 0.0
    
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
        subtitleLabel.text = "요일별 운동 횟수"
        setupChartView()
        updateChartWithData()
    }
    
    fileprivate func setupChartView() {
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
    
    fileprivate func updateChartWithData() {
        let weekdaysCounts = DBHandler.shared.fetchWorkoutsOfDaysByWeekDays()
        
        let dataEntries = weekdaysCounts.enumerated().map { idx, val -> BarChartDataEntry in
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
        
        maxValue = Double(weekdaysCounts.max() ?? 0)
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
