//
//  FormTextField.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/27.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .concaveColor
        clipsToBounds = true
        layer.cornerRadius = 10
        font = .smallestBoldTitle
        textColor = .defaultTextColor
    }
    
    //let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
}
