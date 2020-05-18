//
//  ProfileViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

/*
 요약 =
 
 키
 몸무게
 평균 운동 시간
 주당 운동 횟수
 
 차트 =
 몸무게 변화
 운동량 변화
 */

class ProfileViewController: BasicViewController {
    
    // MARK: Model
    
    fileprivate let popupTransitioningDelegate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.4)
    
    // MARK: View
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var summaryTitleLabel: UILabel!
    
    @IBOutlet weak var summaryEditButton: BasicButton!
    
    @IBOutlet weak var summaryHeightView: SummaryView!
    
    @IBOutlet weak var summaryWeightView: SummaryView!
    
    @IBOutlet weak var summaryBodyFatView: SummaryView!
    
    @IBOutlet weak var summaryMuscleView: SummaryView!
    
    @IBOutlet weak var summaryBmiView: SummaryView!
    
    @IBOutlet weak var highlightTitleLabel: UILabel!
    
    @IBOutlet weak var highlightWeekChartView: HighlightsWeekChartView!
    
    @IBOutlet weak var highlightWorkoutChartView: BasicChartView!
    
    override var navigationBarTitle: String {
        return "프로필"
    }
    
    override func setup() {
        setupSummaries()
        setupHighlights()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .defaultBackgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        highlightWeekChartView.animateChart()
    }
    
    fileprivate func setupSummaries() {
        summaryTitleLabel.textColor = .defaultTextColor
        summaryTitleLabel.font = .smallBoldTitle
        summaryTitleLabel.text = "요약"
        
        summaryEditButton.setTitle("편집", for: .normal)
        summaryEditButton.backgroundColor = .weakTintColor
        summaryEditButton.setTitleColor(.tintColor, for: .normal)
        summaryEditButton.addTarget(self, action: #selector(summaryEditButtonDidTapped(_:)), for: .touchUpInside)
        
        summaryHeightView.subtitleLabel.text = "키"
        summaryWeightView.subtitleLabel.text = "체중"
        summaryBodyFatView.subtitleLabel.text = "체지방"
        summaryMuscleView.subtitleLabel.text = "골격근"
        summaryBmiView.subtitleLabel.text = "BMI"
        
        /* Dummy data for prototype */
        // FIXME: Delete here
        summaryHeightView.unitLabel.text = "cm"
        summaryWeightView.unitLabel.text = "kg"
        summaryBodyFatView.unitLabel.text = "%"
        summaryMuscleView.unitLabel.text = "kg"
        
        summaryHeightView.titleLabel.text = "170"
        summaryWeightView.titleLabel.text = "70"
        summaryBodyFatView.titleLabel.text = "10"
        summaryMuscleView.titleLabel.text = "38"
        summaryBmiView.titleLabel.text = "21"
        /* Dummy data for prototype */
    }
    
    fileprivate func setupHighlights() {
        highlightTitleLabel.textColor = .defaultTextColor
        highlightTitleLabel.font = .smallBoldTitle
        highlightTitleLabel.text = "하이라이트"
        
        highlightWeekChartView.subtitleLabel.text = "요일별 운동 횟수"
    }
}

// MARK: objc functions

extension ProfileViewController {
    @objc
    fileprivate func summaryEditButtonDidTapped(_ sender: UIButton) {
        let editVC = ProfileEditViewController(nibName: "ProfileEditViewController", bundle: nil)
        editVC.transitioningDelegate = popupTransitioningDelegate
        editVC.modalPresentationStyle = .custom
        present(editVC, animated: true, completion: nil)
    }
}
