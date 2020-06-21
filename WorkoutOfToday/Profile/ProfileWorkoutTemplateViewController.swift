//
//  ProfileWorkoutTemplateViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class ProfileWorkoutTemplateViewController: WorkoutTemplateViewController {
    override var navigationBarTitle: String {
        return "운동 선택"
    }
    
    var delegate: WorkoutTemplateDidSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTemplate = templates[indexPath.section][indexPath.item]
        delegate?.workoutTemplateDidSelect(workoutTemplate: selectedTemplate)
        dismiss(animated: true, completion: nil)
    }
}
