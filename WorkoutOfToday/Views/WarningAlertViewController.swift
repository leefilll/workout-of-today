//
//  WarningAlertViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/21.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class WarningAlertViewController: UIViewController {
    
    var titleMessage: String?
    
    var message: String?
    
    var onDoneSelector: Selector?
    
    private weak var titleLable: UILabel!
    
    private weak var messageLabel: UILabel!
    
    private weak var confirmButton: BasicButton!
    
    private weak var cancelButton: BasicButton!
    
    public convenience init(title: String, message: String, onDone: Selector) {
        self.init()
        self.titleMessage = title
        self.message = message
        self.onDoneSelector = onDone
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
        if let onDoneSelector = onDoneSelector {
            confirmButton.addTarget(self, action: onDoneSelector, for: .touchUpInside)
        }
        
        let cancelButton = BasicButton()
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .boldBody
        cancelButton.backgroundColor = .concaveColor
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-35)
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
    }
}

extension WarningAlertViewController {
    @objc
    public func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
