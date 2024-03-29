//
//  BaseView.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/18.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class BasicView: UIView {
    
    public var token: BasicNotificationToken? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public func setup() {
        
    }

}

protocol NibLoadable: UIView {
}

extension NibLoadable {
    func commonInit() {
        let name = String(describing: type(of: self))
        guard let loadedNib = Bundle.main.loadNibNamed(name, owner: self, options: nil) else { return }
        guard let view = loadedNib.first as? UIView else { return }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = self.bounds
        self.addSubview(view)
    }
}
