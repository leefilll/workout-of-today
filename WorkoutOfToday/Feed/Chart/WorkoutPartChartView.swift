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
    
    
    private var percentagesOfParts: [(Part, Int)] = []
    
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
        percentagesOfParts = DBHandler.shared.fetchWorkoutPartInPercentage()
        guard !percentagesOfParts.isEmpty else {
            isEmpty = true
            return
        }
        isEmpty = false
        updateChartWithData()
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
        let occupiedPercentagesOfParts = percentagesOfParts.filter { $0.1 > 0 }
        
        let entries = occupiedPercentagesOfParts
            .map { part, percentage -> PieChartDataEntry in
                return PieChartDataEntry(value: Double(percentage),
                                         label: part.description)
        }
        
        let set = PieChartDataSet(entries: entries)
        set.label = nil
        set.sliceSpace = 3
        set.colors = occupiedPercentagesOfParts.map { $0.0.color }
        set.selectionShift = 0
        set.yValuePosition = .insideSlice
        
        // MARK: with line
//        set.valueLinePart1OffsetPercentage = 0.9
//        set.valueLinePart1Length = 0.4
//        set.valueLinePart2Length = 0.2
//        set.valueLineColor = .defaultTextColor
//        set.valueLineWidth = 2
//        set.yValuePosition = .outsideSlice
//        set.entryLabelColor = .white
//        set.valueTextColor = .defaultTextColor
//        set.entryLabelFont = .boldBody
//        set.valueFont = .subheadline
        
        let data = PieChartData(dataSet: set)
        data.setValueFormatter(chartFormatter!)
        data.setValueFont(UIFont.subheadline)
        
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
//        pieChartView.legend.enabled = false
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
        guard value >= Double(100 / numberOfPart) else { return "" }
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        
        let formattedString = pFormatter.string(from: NSNumber(value: value))
        return formattedString ?? ""
    }
}
