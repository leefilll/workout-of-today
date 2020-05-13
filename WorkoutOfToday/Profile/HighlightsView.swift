//
//  HighlightsView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class HighlightsView: BaseCardView {
    
    var subtitleLabel: UILabel!
    
    var chartContainerView: UIView!
    
    override func setup() {
        setupLabel()
        setupChartView()
    }
    
    fileprivate func setupLabel() {
        let subtitleLabel = UILabel()
        subtitleLabel.font = .subheadline
        subtitleLabel.textColor = .lightGray
        addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
        }

        self.subtitleLabel = subtitleLabel
    }
    
    fileprivate func setupChartView() {
        let chartContainerView = UIView()
        chartContainerView.backgroundColor = .clear
        addSubview(chartContainerView)
        
        chartContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
        }
        
        self.chartContainerView =  chartContainerView
    }
}
