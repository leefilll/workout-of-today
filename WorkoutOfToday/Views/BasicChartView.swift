//
//  HighlightsView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/26.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class BasicChartView: BasicCardView {
    
    // MARK: View
    
    weak var subtitleLabel: UILabel!
    
    weak var chartContainerView: UIView!
    
    weak var emptyLabel: UILabel!
    
    weak var selectButton: BasicButton!
    
    // MARK: Model
    
    var subtitle: String? {
        return ""
    }
    
    var isEmpty: Bool = true {
        didSet {
            updateChartView()
        }
    }
    
    override func setup() {
        super.setup()
        setupLabel()
        setupChartView()
        setupEmptyLabel()
        setupSelectButton()
        updateChartView()
        selectButton.isHidden = true
    }
    
    private func setupLabel() {
        let subtitleLabel = UILabel()
        subtitleLabel.font = .boldBody
        subtitleLabel.textColor = .lightGray
        subtitleLabel.text = subtitle
        addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
        }
        
        self.subtitleLabel = subtitleLabel
    }
    
    private func setupSelectButton() {
        let selectButton = BasicButton()
        selectButton.setTitle(" - ", for: .normal)
        selectButton.contentEdgeInsets =
            UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
        addSubview(selectButton)
        
        selectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(subtitleLabel.snp.centerY)
        }
        self.selectButton = selectButton
    }
    
    private func setupChartView() {
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
    
    private func setupEmptyLabel() {
        let emptyLabel = UILabel()
        emptyLabel.font = .subheadline
        emptyLabel.text = "차트를 위한 정보가 부족합니다."
        addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        self.emptyLabel = emptyLabel
    }
    
    private func updateChartView() {
        if isEmpty {
            emptyLabel.isHidden = false
            chartContainerView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            chartContainerView.isHidden = false
        }
    }
}

