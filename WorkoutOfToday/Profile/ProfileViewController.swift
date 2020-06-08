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
    
    private let popupTransitioningDelegate = PopupTransitioningDelegate(height: 400)
    
    lazy private var popupTransitioningDelegateForTemplate = PopupTransitioningDelegate(height: self.view.bounds.height * 3 / 4)
    
    private var user: Profile? {
        didSet {
            updateSummaries()
        }
    }
    
    // MARK: View
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var summaryCoverView: BasicCardView!
    
    @IBOutlet weak var summaryTitleLabel: UILabel!
    
    @IBOutlet weak var summaryEditButton: BasicButton!
    
    @IBOutlet weak var summaryHeightView: SummaryView!
    
    @IBOutlet weak var summaryWeightView: SummaryView!
    
    @IBOutlet weak var summaryBodyFatView: SummaryView!
    
    @IBOutlet weak var summaryMuscleView: SummaryView!
    
    @IBOutlet weak var summaryBmiView: SummaryView!
    
    @IBOutlet weak var highlightTitleLabel: UILabel!
    
//    @IBOutlet weak var highlightWeekChartView: HighlightsWeekChartView!
    
    @IBOutlet weak var highlightPartChartView: WorkoutPartChartView!
    
    @IBOutlet weak var highlightVolumeChartView: WorkoutVolumeChartView!
    
    override var navigationBarTitle: String {
        return "프로필"
    }
    
    override func setup() {
        setupSummaries()
        setupHighlights()
        updateSummaries()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .defaultBackgroundColor
        highlightPartChartView.animateChart()
        highlightVolumeChartView.animateChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        highlightWeekChartView.animateChart()
    }
    
    override func setupFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }
    
    override func registerNotifications() {
        registerNotification(.WorkoutDidAdded) { [weak self] note in
            self?.highlightPartChartView.setupModel()
        }
        registerNotification(.WorkoutDidDeleted) { [weak self] note in
            self?.highlightPartChartView.setupModel()
        }
    }
    
    private func setupSummaries() {
        let profile = DBHandler.shared.fetchObjects(ofType: Profile.self)
        if let user = profile.first {
            self.user = user
        }
        
        summaryTitleLabel.textColor = .defaultTextColor
        summaryTitleLabel.font = .smallBoldTitle
        summaryTitleLabel.text = "요약"
        
        summaryEditButton.setTitle("편집", for: .normal)
        summaryEditButton.setBackgroundColor(.weakTintColor, for: .normal)
        summaryEditButton.setTitleColor(.tintColor, for: .normal)
        summaryEditButton.addTarget(self, action: #selector(summaryEditButtonDidTapped(_:)), for: .touchUpInside)
        
        summaryHeightView.subtitleLabel.text = "키"
        summaryWeightView.subtitleLabel.text = "체중"
        summaryBodyFatView.subtitleLabel.text = "체지방"
        summaryMuscleView.subtitleLabel.text = "골격근"
        summaryBmiView.subtitleLabel.text = "BMI"
        
        summaryHeightView.unitLabel.text = "cm"
        summaryWeightView.unitLabel.text = "kg"
        summaryBodyFatView.unitLabel.text = "%"
        summaryMuscleView.unitLabel.text = "kg"
        summaryBmiView.unitLabel.text = ""
    }
    
    private func updateSummaries() {
        if let user = user {
            summaryCoverView.isHidden = true
            summaryHeightView.mainLabel.text = String(format: "%.1f", user.height)
            summaryWeightView.mainLabel.text = String(format: "%.1f", user.getRecentWeight())
            summaryBodyFatView.mainLabel.text = String(format: "%.0f", user.fatPercentage)
            summaryMuscleView.mainLabel.text = String(format: "%.0f", user.muscleWeight)
            
            let (bmiDegree, _) = user.getBMI()
            summaryBmiView.mainLabel.text = String(format: "%.1f", bmiDegree)
        } else {
            summaryCoverView.isHidden = false
            let descriptionLabel = UILabel()
            descriptionLabel.text = "정보가 등록되지 않았습니다."
            descriptionLabel.font = .subheadline
            descriptionLabel.textColor = .lightGray
            
            summaryCoverView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    private func setupHighlights() {
        highlightTitleLabel.textColor = .defaultTextColor
        highlightTitleLabel.font = .smallBoldTitle
        highlightTitleLabel.text = "하이라이트"
        
        highlightVolumeChartView.selectButton.addTarget(self, action: #selector(selectTemplateButtonDidTapped(_:)), for: .touchUpInside)
    }
}

// MARK: objc functions

extension ProfileViewController {
    @objc
    private func summaryEditButtonDidTapped(_ sender: UIButton) {
        let editVC = ProfileEditViewController(nibName: "ProfileEditViewController", bundle: nil)
        editVC.transitioningDelegate = popupTransitioningDelegate
        editVC.modalPresentationStyle = .custom
        editVC.delegate = self
        editVC.user = user
        selectionFeedbackGenerator?.selectionChanged()
        present(editVC, animated: true, completion: nil)
    }
    
    @objc
    private func selectTemplateButtonDidTapped(_ sender: UIButton) {
        let vc = ProfileWorkoutTemplateViewController()
        vc.delegate = self
        vc.transitioningDelegate = popupTransitioningDelegateForTemplate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)
    }
}

// MARK: Delegates

extension ProfileViewController: ProfileDidUpdatedDelegate {
    func profileDidUpdated() {
        guard let user = DBHandler.shared.fetchObjects(ofType: Profile.self).first else { return }
        self.user = user
    }
}

extension ProfileViewController: WorkoutTemplateDidSelectedDelegate {
    func workoutTemplateDidSelect(workoutTemplate: WorkoutTemplate) {
        highlightVolumeChartView.updateWorkoutTemplate(workoutTemplate: workoutTemplate)
    }
}

protocol ProfileDidUpdatedDelegate {
    func profileDidUpdated()
}

protocol WorkoutTemplateDidSelectedDelegate {
    func workoutTemplateDidSelect(workoutTemplate: WorkoutTemplate)
}
