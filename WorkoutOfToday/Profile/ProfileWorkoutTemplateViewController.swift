//
//  ProfileWorkoutTemplateViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SwiftIcons

class ProfileWorkoutTemplateViewController: WorkoutTemplateViewController {
    
    var delegate: WorkoutTemplateDidSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
    }
    
    private func setupHeader() {
        headerLabel.text = "운동 선택"
        
        let closeButton = UIButton()
        closeButton.addTarget(self,
                              action: #selector(closeButtonDidTapped(_:)),
                              for: .touchUpInside)
        closeButton.setIcon(icon: .ionicons(.iosClose),
                            iconSize: 27,
                            color: .lightGray2,
                            backgroundColor: .clear,
                            forState: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTemplate = templates[indexPath.section][indexPath.item]
        delegate?.workoutTemplateDidSelect(workoutTemplate: selectedTemplate)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: objc functions

extension ProfileWorkoutTemplateViewController {
    @objc
    func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
