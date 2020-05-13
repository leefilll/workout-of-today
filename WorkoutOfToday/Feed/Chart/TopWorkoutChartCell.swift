////
////  TopWorkoutChartView.swift
////  WorkoutOfToday
////
////  Created by Lee on 2020/04/21.
////  Copyright © 2020 Lee. All rights reserved.
////
//
//import UIKit
//
//import RealmSwift
//import Charts
//
//class TopWorkoutChartCell: UITableViewCell, NibLoadable {
//    
//    // MARK: Model
//    
//    let totalWorkouts: Results<Workout> = DBHandler.shared.fetchObjects(ofType: Workout.self)
//    
//    var mostFrequentWorkouts: [Dictionary<String, Int>.Element]?
//        
//    weak var axisFormatDelegate: IAxisValueFormatter?
//    
//    // MARK: View
//    
//    @IBOutlet weak var barChartView: BarChartView!
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    fileprivate func setup() {
//        commonInit()
//        backgroundColor = .clear
//        
//        contentView.backgroundColor = .white
//        contentView.clipsToBounds = true
//        contentView.layer.cornerRadius = 10
//        
//        
//        axisFormatDelegate = self
//        updateChartWithData()
//    }
//    
//    func updateChartWithData() {
//        
//        mostFrequentWorkouts = DBHandler.shared.fetcthMostFrequentWorkouts(workouts: self.totalWorkouts)
//        guard let mostFrequentWorkouts = mostFrequentWorkouts else { return }
//        var dataEntries: [BarChartDataEntry] = []
//        for i in 0..<mostFrequentWorkouts.count {
//            let workoutFrequency = mostFrequentWorkouts[i].value
//            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(workoutFrequency))
//            dataEntries.append(dataEntry)
//        }
//        let chartDataSet = BarChartDataSet(entries: dataEntries)
//        chartDataSet.drawValuesEnabled = true
//        let chartData = BarChartData(dataSet: chartDataSet)
//        chartData.barWidth = 0.8
//        barChartView.data = chartData
//        
//        let xAxis = barChartView.xAxis
//        xAxis.labelPosition = .bottom
//        xAxis.gridLineWidth = 0
//        xAxis.labelFont = .systemFont(ofSize: 10)
//        xAxis.granularity = 1
//        xAxis.valueFormatter = axisFormatDelegate
////        xAxis.labelRotationAngle = -45
//        
//        barChartView.setScaleEnabled(false)
//        barChartView.legend.enabled = false
//        barChartView.chartDescription?.enabled = false
//        barChartView.fitBars = false
//        barChartView.maxVisibleCount = 5
//        barChartView.rightAxis.enabled = false
//        barChartView.leftAxis.enabled = false
//        barChartView.gridBackgroundColor = .red
//        barChartView.setExtraOffsets(left: 0, top: 10, right: 0, bottom: 10)
//    }
//}
//
//extension TopWorkoutChartCell: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let index = Int(value)
//        let workoutName = self.mostFrequentWorkouts?[index].key
//        
//        
//        return workoutName ?? ""
//    }
//}
