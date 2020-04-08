//
//  AddWorkoutTableViewCell.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SnapKit

class AddWorkoutTableViewCell: UITableViewCell {
    
    private var containerView: UIView!
    
    var isAddingCell: Bool = false {
        willSet {
                setAddButton.isHidden = !newValue
                containerView.isHidden = newValue
        }
    }
    
    var delegate: AddingWorkoutSet?
    
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
        let tintColor = UIColor.tintColor
        setAddButton.backgroundColor = tintColor.withAlphaComponent(0.5)
        setAddButton.isHidden = true
        setAddButton.layer.cornerRadius = 10
        setAddButton.layer.masksToBounds = true
        setAddButton.addTarget(self, action: #selector(addWorkoutSet(_:)), for: .touchUpInside)
        
        containerView = UIView()
        
        countLabel = UILabel()
        countLabel.text = "33"
        
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
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        addSubview(setAddButton)
        addSubview(containerView)
        containerView.addSubview(countLabel)
        containerView.addSubview(stackView)
        
        setAddButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(countLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc func addWorkoutSet(_ sender: UIButton) {
        delegate?.addWorkoutSet()
//        print("TAP")
    }
}


protocol AddingWorkoutSet {
    func addWorkoutSet()
}
