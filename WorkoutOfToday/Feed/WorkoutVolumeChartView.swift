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
    
    fileprivate var volumesByDate: [(date: Date, volume: Int)]?
    
    fileprivate var valueFormatter: IValueFormatter?
    
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
            make.top.equalToSuperview().offset(10)
        }
        valueFormatter = self
        lineChartView.delegate = self
        
        self.lineChartView = lineChartView
    }
    
    fileprivate func updateChartWithData() {
        
        volumesByDate = DBHandler.shared.fechWorkoutVolumeByPeriod(workoutName: workoutName, period: period)
        guard let volumesByDate = volumesByDate else { fatalError() }
        print(volumesByDate)

        // MARK: note that x value used for index
        let entries = volumesByDate.enumerated().map { idx, value -> ChartDataEntry in
            let volume = value.volume
            print("volume: \(volume)")
            return ChartDataEntry(x: Double(idx), y: Double(volume))
        }
        
        let set1 = LineChartDataSet(entries: entries)
        set1.drawIconsEnabled = false
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setValueFormatter(valueFormatter!)
//        data.setvalu
        
        lineChartView.data = data
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.pinchZoomEnabled = false
        lineChartView.rightAxis.enabled = false
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
    }
    
    func animateChart() {
    }
    
}

extension WorkoutVolumeChartView: ChartViewDelegate {
    
}

extension WorkoutVolumeChartView: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        pFormatter.multiplier = 1
        pFormatter.groupingSeparator = ","
        
        guard let formattedString = pFormatter.string(from: NSNumber(value: value)) else {
            return ""
        }
        
        return formattedString + " kg"
    }
}
