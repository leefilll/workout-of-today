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

class ProfileViewController: BaseViewController {
    
    // MARK: Model
    
    fileprivate let popupTransitioningDelegate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.4)
    
    
    // MARK: View
    
    @IBOutlet weak var summaryTitleLabel: UILabel!
    
    @IBOutlet weak var summaryEditButton: BaseButton!
    
    @IBOutlet weak var summaryInfoView: SummaryView!
    
    @IBOutlet weak var summaryWorkoutView: SummaryView!
    
    @IBOutlet weak var highlightTitleLabel: UILabel!
    
    override var navigationBarTitle: String {
        return "프로필"
    }
    
    override func setup() {
        setupSummaries()
        setupHighlights()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func setupSummaries() {
        summaryTitleLabel.font = .smallBoldTitle
        summaryTitleLabel.text = "요약"
        
        summaryEditButton.setTitle("편집", for: .normal)
        summaryEditButton.backgroundColor = .weakTintColor
        summaryEditButton.setTitleColor(.tintColor, for: .normal)
        summaryEditButton.addTarget(self, action: #selector(summaryEditButtonDidTapped(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupHighlights() {
        highlightTitleLabel.font = .smallBoldTitle
        highlightTitleLabel.text = "하이라이트"
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
