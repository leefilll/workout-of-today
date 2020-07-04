//
//  DraggableNavigationController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/07/04.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class DraggableNavigationController: UINavigationController {
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private var originMinY: CGFloat!
    
    private var originMaxY: CGFloat!
    
    private var minimumVelocityToHide: CGFloat = 1200
    
    private var minimumScreenRatioToHide: CGFloat = 0.3
    
    private var animationDuration: TimeInterval = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dragBar = UIView()
        dragBar.backgroundColor = .weakGray
        dragBar.layer.cornerRadius = 3
        view.addSubview(dragBar)
        dragBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7)
            make.width.equalTo(40)
            make.height.equalTo(5)
        }
        setupPanGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originMinY = view.frame.minY
        originMaxY = view.frame.maxY
    }
    
    private func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidBegin(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func panGestureDidBegin(_ sender: UIPanGestureRecognizer) {
        func slideViewVerticallyTo(_ y: CGFloat) {
            view.frame.origin = CGPoint(x: 0, y: y)
        }
        
        switch sender.state {
            case .began, .changed:
                let translation = sender.translation(in: view)
                let y = max(originMinY, originMinY + translation.y)
                slideViewVerticallyTo(y)
            case .ended:
                let translation = sender.translation(in: view)
                let velocity = sender.velocity(in: view)
                let closing = (translation.y > view.frame.height * minimumScreenRatioToHide) ||
                    (velocity.y > minimumVelocityToHide)
                
                if closing {
                    UIView.animate(withDuration: animationDuration, animations: {
                        slideViewVerticallyTo(self.originMaxY)
                    }, completion: { (isCompleted) in
                        if isCompleted {
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                } else {
                    UIView.animate(withDuration: animationDuration, animations: {
                        slideViewVerticallyTo(self.originMinY)
                    })
            }
            default:
                UIView.animate(withDuration: animationDuration, animations: {
                    slideViewVerticallyTo(self.originMinY)
                })
        }
    }
}
