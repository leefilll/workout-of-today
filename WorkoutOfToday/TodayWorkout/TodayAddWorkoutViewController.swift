//
//  TodayAddWorkoutViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import DZNEmptyDataSet
import SwiftIcons

class TodayAddWorkoutViewController: WorkoutTemplateViewController {
    
    private weak var searchBar: UISearchBar!
    
    // MARK: Model
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    private var originMinY: CGFloat!
    
    private var originMaxY: CGFloat!
    
    private var minimumVelocityToHide: CGFloat = 1200
    
    private var minimumScreenRatioToHide: CGFloat = 0.3
    
    private var animationDuration: TimeInterval = 0.2
    
    private let popupTransitioningDelegateForTemplate = PopupTransitioningDelegate(widthRatio: 0.95, heightRatio: 0.50)
    
    var searchedTemplates: [[WorkoutTemplate]]?
    
    override var navigationBarTitle: String {
        return "운동 추가"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(containerViewDidTapped(_:)))
        collectionView.delegate = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        searchedTemplates = templates
        navigationController?.isNavigationBarHidden = true
        setupPanGestureRecognizer()
        setupHeader()
        setupSearchBar()
        setupCollectionViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originMinY = view.frame.minY
        originMaxY = view.frame.maxY
    }
    
    private func setupHeader() {
        headerLabel.text = "운동 추가"
        
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
        
        let templateAddButton = UIButton()
        templateAddButton.setTitle("템플릿", for: .normal)
        templateAddButton.setTitleColor(.tintColor, for: .normal)
        templateAddButton.titleLabel?.font = .smallestBoldTitle
        templateAddButton.addTarget(self,
                                    action: #selector(templateAddButtonDidTapped(_:)),
                                    for: .touchUpInside)
        view.addSubview(templateAddButton)
        templateAddButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "템플릿 검색"
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        self.searchBar = searchBar
    }
    
    private func setupCollectionViewLayout() {
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidBegin(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    override func keyboardWillShow(in bounds: CGRect?) {
        guard let keyboardHeight = bounds?.height else { return }
        collectionView.contentInset.bottom += keyboardHeight
    }
    
    override func keyboardWillHide() {
        collectionView.contentInset.bottom = 20
    }
}

// MARK: AddWorkoutTemplate Delegate

extension TodayAddWorkoutViewController: AddWorkoutTemplate {
    func workoutTemplateDidAdded() {
        collectionView.reloadData()
    }
}

// MARK: objc functions

extension TodayAddWorkoutViewController {
    @objc
    func templateAddButtonDidTapped(_ sender: UITapGestureRecognizer?) {
        let vc = TodayWorkoutTemplateAddViewController(nibName: "TodayWorkoutTemplateAddViewController", bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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

// MARK: CollectionView Delegate

extension TodayAddWorkoutViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTemplate = templates[indexPath.section][indexPath.item]
        
        DBHandler.shared.write {
            let newWorkout = Workout()
            newWorkout.template = selectedTemplate
            DBHandler.shared.realm.add(newWorkout)
        }
        
        postNotification(.WorkoutDidAdded)
        selectionFeedbackGenerator?.selectionChanged()
        dismiss(animated: true, completion: nil)
    }
}

extension TodayAddWorkoutViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: DZNEmptyDataSet DataSource and Delegate

extension TodayAddWorkoutViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        for template in templates {
            if !template.isEmpty {
                return false
            }
        }
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let iconImage = UIImage.init(icon: .ionicons(.iosInformationOutline),
                                     size: CGSize(width: 70, height: 70),
                                     textColor: .lightGray)
        return iconImage
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "운동 템플릿이 없습니다"
        let font = UIFont.smallBoldTitle
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "운동 템플릿을 등록하면\n간편하게 운동을 추가할 수 있습니다."
        let font = UIFont.subheadline
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let attributedString = NSAttributedString(string: str, attributes: attributes)
        return attributedString
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        templateAddButtonDidTapped(nil)
    }
}
