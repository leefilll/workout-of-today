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
    
    private var volumesByDate: [(date: Date, volume: Double)]? {
        didSet {
            updateChartWithData()
        }
    }
    
    private var valueFormatter: IValueFormatter?
    
    private var xAxisFormatter: IAxisValueFormatter?
    
    private var yAxisFormatter: IAxisValueFormatter?
    
    private var maxValue: Double = 0.0
    
    override var subtitle: String? {
        return "운동별 볼륨량 변화"
    }
    
    var workoutTemplate: WorkoutTemplate? {
        didSet {
            selectButton.setTitle(workoutTemplate?.name, for: .normal)
            selectButton.setTitleColor(workoutTemplate?.part.color, for: .normal)
            selectButton.backgroundColor = workoutTemplate?.part.color.withAlphaComponent(0.1)
        }
    }
    
    // MARK: At first, set workoutTemplate to first thing
    override func setup() {
        super.setup()
        setupSelectButton()
        setupChartView()
        setupModel()
    }
    
    private func setupSelectButton() {
        selectButton.isHidden = false
    }
    
    private func setupModel() {
        if let tempTemplate = DBHandler.shared.fetchObjects(ofType: WorkoutTemplate.self).first {
            updateWorkoutTemplate(workoutTemplate: tempTemplate)
        }
    }
    
    func updateWorkoutTemplate(workoutTemplate: WorkoutTemplate) {
        self.workoutTemplate = workoutTemplate
        volumesByDate = DBHandler.shared.fetchWorkoutVolumes(workoutTemplate: workoutTemplate)
    }
    
    private func setupChartView() {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .clear
        
        chartContainerView.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        xAxisFormatter = self
        valueFormatter = self
        lineChartView.delegate = self
        lineChartView.rightAxis.enabled = false
        lineChartView.chartDescription?.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.extraRightOffset = 30
        lineChartView.extraLeftOffset = 30
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = false
        lineChartView.isUserInteractionEnabled = true
        lineChartView.leftAxis.enabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.drawMarkers = true
        self.lineChartView = lineChartView
    }
    
    private func updateChartWithData() {
        guard let workoutTemplate = workoutTemplate,
            let volumesByDate = volumesByDate,
            volumesByDate.count > 1 else {
                isEmpty = true
                lineChartView.marker = nil
                return
        }
        
        isEmpty = false
        
        // MARK: note that x value used for index
        let entries = volumesByDate.enumerated().map { idx, value -> ChartDataEntry in
            let volume = value.volume
            return ChartDataEntry(x: Double(idx), y: Double(volume))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.drawIconsEnabled = false
        set.highlightLineDashLengths = [5, 2.5]
        set.setColor(workoutTemplate.part.color)
        
        set.drawCirclesEnabled = entries.count < 20
        set.drawCircleHoleEnabled = true
        set.setCircleColor(workoutTemplate.part.color)
        set.circleHoleColor = workoutTemplate.part.color.withAlphaComponent(0.1)
        set.circleRadius = 4
        set.circleHoleRadius = 2
        
        set.lineWidth = 2
        set.valueFont = .subheadline
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 1
        set.formSize = 15
        set.drawFilledEnabled = false
        set.highlightLineWidth = 0
        
        let data = LineChartData(dataSet: set)
        data.setValueFormatter(valueFormatter!)
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.gridLineWidth = 0
        xAxis.granularity = 1
        xAxis.labelCount = 4
        xAxis.labelFont = .description
        xAxis.labelTextColor = .lightGray
        xAxis.axisLineWidth = 1
        xAxis.axisLineColor = .concaveColor
        xAxis.valueFormatter = xAxisFormatter
        
        
        let marker = ChartMarkerView(color: .weakGray,
                                     font: .subheadline,
                                     textColor: .black,
                                     insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                     style: workoutTemplate.style)
        marker.chartView = lineChartView
        lineChartView.marker = marker
        lineChartView.data = data
    }
    
    func animateChart() {
        lineChartView.animate(xAxisDuration: 0.8)
    }
}

// MARK: ChartView Delegate

extension WorkoutVolumeChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
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
        guard isEmpty == false, let axis = axis else { return "" }
        if axis == lineChartView.xAxis {
            guard let volumesByDate = volumesByDate else { return "" }
            let date = volumesByDate[Int(value)].date
            let formatter = DateFormatter.shared
            formatter.setLocalizedDateFormatFromTemplate("MMMM-d")
            let dateString = formatter.string(from: date)
            return dateString
            
        } else {
            if value == maxValue {
                let nFormatter = NumberFormatter()
                nFormatter.numberStyle = .decimal
                return "\(value)kg"
            }
            return ""
        }
    }
}
