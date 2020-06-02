//
//  WarningAlertViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class WarningAlertViewController: BasicViewController {
    
    var titleMessage: String?
    
    var message: String?
    
//    var delegate: WorkoutDidModiFieid?
    
    var primaryKeyToDelete: String?
    
    private weak var titleLable: UILabel!
    
    private weak var messageLabel: UILabel!
    
    private weak var confirmButton: BasicButton!
    
    private weak var cancelButton: BasicButton!
    
    convenience init(title: String, message: String, primaryKey: String) {
        self.init()
        self.titleMessage = title
        self.message = message
        self.primaryKeyToDelete = primaryKey
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = .smallBoldTitle
        titleLabel.textAlignment = .center
        titleLabel.text = titleMessage
        
        let messageLabel = UILabel()
        messageLabel.font = .body
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        
        let confirmButton = BasicButton()
        confirmButton.setTitle("삭제", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = .boldBody
        confirmButton.backgroundColor = Part.chest.color
        confirmButton.addTarget(self, action: #selector(deleteWorkout(_:)), for: .touchUpInside)
        
        let cancelButton = BasicButton()
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .boldBody
        cancelButton.backgroundColor = .concaveColor
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(40)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
        
        self.titleLable = titleLabel
        self.messageLabel = messageLabel
        self.confirmButton = confirmButton
        self.cancelButton = cancelButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func setupFeedbackGenerator() {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator?.prepare()
    }
}

extension WarningAlertViewController {
    @objc
    private func deleteWorkout(_ sender: UIButton) {
        guard let primaryKeyToDelete = primaryKeyToDelete,
            let workoutToDelete = DBHandler.shared.fetchObject(ofType: Workout.self, forPrimaryKey: primaryKeyToDelete) else {
                fatalError("Error occurs in \(#function)")
        }
        DBHandler.shared.delete(object: workoutToDelete)
        postNotification(.WorkoutDidDeleted)
//        delegate?.workoutDidDeleted()
        impactFeedbackGenerator?.impactOccurred()
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
