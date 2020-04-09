//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

final class AddWorkoutTableViewCell: UITableViewCell {
    
    // properties
    var delegate: AddingWorkoutSet?
    
    var isAddingCell: Bool = false {
           willSet {
                   setAddButton.isHidden = !newValue
                   containerView.isHidden = newValue
           }
       }
    
    
    // UI
    private var containerView: UIView!
    
    var setAddButton: UIButton!
    
    var countLabel: UILabel!
    
    var weightTextField: UITextField!
    
    var repsTextField: UITextField!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        delegate = nil
    }
    
    private func setup() {
        setAddButton = UIButton()
        setAddButton.setTitle("세트 추가", for: .normal)
        setAddButton.backgroundColor = UIColor.tintColor.withAlphaComponent(0.5)
        setAddButton.isHidden = true
        setAddButton.layer.cornerRadius = 10
        setAddButton.layer.masksToBounds = true
        setAddButton.addTarget(self, action: #selector(addWorkoutSet(_:)), for: .touchUpInside)
        
        containerView = UIView()
        
        countLabel = UILabel()
        countLabel.textAlignment = .center
        
        weightTextField = UITextField()
        weightTextField.placeholder = "kg"
        weightTextField.backgroundColor = UIColor.colorWithRGBHex(hex: 0xe2e3e6)
        weightTextField.font = UIFont.preferredFont(forTextStyle: .body)
        weightTextField.textAlignment = .center
        weightTextField.layer.cornerRadius = 10
        
        repsTextField = UITextField()
        repsTextField.placeholder = "0"
        repsTextField.backgroundColor = UIColor.colorWithRGBHex(hex: 0xe2e3e6)
        repsTextField.font = UIFont.preferredFont(forTextStyle: .body)
        repsTextField.textAlignment = .center
        repsTextField.layer.cornerRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [weightTextField, repsTextField])
        stackView.configureForWorkoutSet()
        
        addSubview(setAddButton)
        addSubview(containerView)
        containerView.addSubview(countLabel)
        containerView.addSubview(stackView)
        
        setAddButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Inset.Cell.veticalInset)
            make.bottom.equalToSuperview().offset(-Inset.Cell.veticalInset)
            make.leading.equalToSuperview().offset(Inset.Cell.horizontalInset)
            make.trailing.equalToSuperview().offset(-Inset.Cell.horizontalInset)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(countLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    @objc func addWorkoutSet(_ sender: UIButton) {
        delegate?.addWorkoutSet()
    }
}


protocol AddingWorkoutSet {
    func addWorkoutSet()
}
