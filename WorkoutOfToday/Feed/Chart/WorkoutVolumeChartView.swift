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

class WorkoutVolumeChartView: BasicChartView {
    
    // MARK: View
    
    private weak var lineChartView: LineChartView!
    
    // MARK: Model
    
    private var volumesByDate: [(date: Date, volume: Double)]?
    
    private var valueFormatter: IValueFormatter?
    
    private var xAxisFormatter: IAxisValueFormatter?
    
    private let popupTransitioningDelegate = PopupTransitioningDelegate(height: 500)
    
    override var subtitle: String? {
        return "운동별 볼륨량 변화"
    }
    
    var workoutTemplate: WorkoutTemplate? {
        didSet {
            if workoutTemplate != nil {
                isEmpty = false
            }
        }
    }
    
    var workoutName: String = "데드리프트" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: At first, set workoutTemplate to first thing
    override func setup() {
        super.setup()
        setupChartView()
        setupModel()
        updateChartWithData()
        setupSelectButton()
    }
    
    private func setupSelectButton() {
        selectButton.isHidden = false
        guard let workoutTemplate = workoutTemplate else {
            return
        }
        selectButton.setTitle(workoutTemplate.name, for: .normal)
    }
    
    private func setupModel() {
          let tempTemplate = DBHandler.shared.fetchObjects(ofType: WorkoutTemplate.self)
          if !tempTemplate.isEmpty {
              workoutTemplate = tempTemplate[0]
          }
      }
    
    private func setupChartView() {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .clear
        
        chartContainerView.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        valueFormatter = self
        xAxisFormatter = self
        lineChartView.delegate = self
        self.lineChartView = lineChartView
    }
            
    private func updateChartWithData() {
        guard let workoutTemplate = workoutTemplate else { return }
        volumesByDate = DBHandler.shared.fetchWorkoutVolumes(workoutTemplate: workoutTemplate)
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
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print(entry)
//    }
}

// MARK: Value Formatter Delegate

extension WorkoutVolumeChartView: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
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
