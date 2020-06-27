//
//  WorkoutPartChartView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/23.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import Charts

class WorkoutPartChartView: BasicChartView {
    
    // MARK: View
    
    private weak var pieChartView: PieChartView!
    
    // MARK: Model
    
    
    private var mostFrequentParts: [Int] = []
    
    private var chartFormatter: IValueFormatter?
    
    override var subtitle: String? {
        return "부위별 빈도 비율"
    }
    
    override func setup() {
        super.setup()
        setupChartView()
        setupModel()
    }
    
    func setupModel() {
        mostFrequentParts = DBHandler.shared.fetchWorkoutPartInPercentage()
        if mostFrequentParts == [0] {
            isEmpty = true
            return
        } else {
            isEmpty = false
            updateChartWithData()
        }
    }
    
    private func setupChartView() {
        let pieChartView = PieChartView()
        pieChartView.backgroundColor = .clear
        
        chartContainerView.addSubview(pieChartView)
        pieChartView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        chartFormatter = self
        self.pieChartView = pieChartView
    }
    
    private func updateChartWithData() {
        if isEmpty { return }
        let entries = mostFrequentParts
            .enumerated()
            .map { idx, count -> PieChartDataEntry in
                return PieChartDataEntry(value: Double(count),
                                         label: Part.string(from: idx))}

        let set = PieChartDataSet(entries: entries)
        set.label = nil
        set.sliceSpace = 3
        set.colors = Part.allCases.map { return $0.color }
        set.selectionShift = 0
        set.yValuePosition = .insideSlice
        
        let data = PieChartData(dataSet: set)
        data.setValueFormatter(chartFormatter!)
        
        let valueFont: UIFont = .boldBody
        data.setValueFont(valueFont)
        data.setValueTextColor(.white)
        
        let l = pieChartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .center
        l.orientation = .vertical
        l.font = .description
        l.form = Legend.Form.circle
        l.formSize = 7
        l.xEntrySpace = 0
        l.yEntrySpace = 0
        l.yOffset = -10
        l.xOffset = 20
        
        pieChartView.data = data
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.425
        pieChartView.holeColor = .clear
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.transparentCircleColor = NSUIColor.white.withAlphaComponent(0.1)
        pieChartView.transparentCircleRadiusPercent = 0.48
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.chartDescription?.enabled = false
        pieChartView.rotationEnabled = false
        pieChartView.highlightValues(nil)
        pieChartView.sizeToFit()
        pieChartView.notifyDataSetChanged()
    }
    
    func animateChart() {
        pieChartView.animate(yAxisDuration: 0.8)
    }
}

extension WorkoutPartChartView: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let numberOfPart = Part.allCases.count
        
        if value < Double(100 / numberOfPart) {
            return ""
        }

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        
        let formattedString = pFormatter.string(from: NSNumber(value: value))
        return formattedString ?? ""
    }
}
