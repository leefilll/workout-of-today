//
//  ChartsViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import Charts

class ChartsViewController: BaseViewController, Childable {
    
    // MARK: Model
    
    var workoutsOfDays: Results<WorkoutsOfDay>!
    
    // MARK: View
    
    fileprivate weak var containerTableView: UITableView!
    
    override func setup() {
        configureContainerTableView()
    }
    
    fileprivate func configureContainerTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 300
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopWorkoutChartCell.self)
        tableView.register(UITableViewCell.self)
        
        view.insertSubview(tableView, at: 0)
        self.containerTableView = tableView
        
        self.containerTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.paddingHorizontal)
            make.trailing.equalToSuperview().offset(-Inset.paddingHorizontal)
            make.bottom.equalToSuperview()
        }
    }
//
//    fileprivate func configureTopWorkoutChartView() {
//        let chartView = TopWorkoutChartView()
//
//        view.addSubview(chartView)
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK: TableView Delegate

extension ChartsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }
        return 250
    }
}

// MARK: TableView DataSource

extension ChartsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(TopWorkoutChartCell.self, for: indexPath)
//            cell.axisFormatDelegate = self
//            cell.totalWorkouts =
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
            
            cell.textLabel?.text = "\(indexPath.section)"
            return cell
        }
    }
}
