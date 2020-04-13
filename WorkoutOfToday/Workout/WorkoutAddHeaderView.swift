//
//  AddWorkoutHeaderView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/13.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class WorkoutAddHeaderView: UIView {
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    
    @IBOutlet weak var workoutPartButton: WorkoutPartButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        self.setup()
    }
    
    override func awakeFromNib() {
        print(#function)
    }
    
    private func commonInit(){
        let name = String(describing: type(of: self))
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return }
        guard let view = loadedNib.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    
    private func setup() {
        self.workoutNameTextField.font = .largeTitle
        self.workoutNameTextField.placeholder = "운동 이름"
        self.workoutNameTextField.minimumFontSize = UIFont.largeTitle.pointSize
    }
}

