//
//  WorkoutTemplateCollectionViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift

class WorkoutTemplateViewController: BasicViewController {

    // MARK: View
    
    @IBOutlet weak var templateCollectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var dragBar: UIView!
    
    // MARK: Model
    
    var templates: [[WorkoutTemplate]] {
        let templates = DBHandler.shared.fetchObjects(ofType: WorkoutTemplate.self)
        var partArray = [[WorkoutTemplate]](repeating: [], count: Part.allCases.count)
        templates.forEach { template in
            let rawValue = template.part.rawValue
            partArray[rawValue].append(template)
        }
        return partArray
    }
    
    var searchedTemplates: [[WorkoutTemplate]]?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "WorkoutTemplateViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setup() {
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchedTemplates = templates
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        setupDragBar()
    }
    
    override func configureNavigationBar() {
        navigationBar.topItem?.title = navigationBarTitle
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
    
    override func setupFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }
    
    private func setupDragBar() {
        dragBar.backgroundColor = .lightGray
        dragBar.layer.cornerRadius = 3
    }
    
    private func setupCollectionView() {
        if let layout = templateCollectionView.collectionViewLayout as? FeedCollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 3
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        templateCollectionView.contentInset.bottom = 40
        templateCollectionView.delegate = self
        templateCollectionView.dataSource = self
        templateCollectionView.delaysContentTouches = false
        templateCollectionView.register(LabelCollectionViewCell.self)
        templateCollectionView.registerForHeaderView(TodayAddWorkoutCollectionHeaderView.self)
    }
}

// MARK: objc functions

extension WorkoutTemplateViewController {
    @objc
    func containerViewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: CollectionView Delegate

extension WorkoutTemplateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if templates[section].count == 0 {
            return .zero
        }
        return CGSize(width: 0, height: 40)
    }
}

// MARK: CollectionView DataSourec

extension WorkoutTemplateViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(TodayAddWorkoutCollectionHeaderView.self, for: indexPath)
        let part = Part.allCases[indexPath.section]
        header.titleLabel.text = part.description
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(LabelCollectionViewCell.self,
                                                      for: indexPath)
        cell.content = templates[indexPath.section][indexPath.item]
        return cell
    }
}

// MARK: CollectionView Delegate Flow Layout

extension WorkoutTemplateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let workoutTemplate = templates[indexPath.section][indexPath.item]
        let templateString = workoutTemplate.name
        let itemSize = templateString.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.smallBoldTitle
        ])

        let extraWidth: CGFloat = 30
        let insetHorizontal = collectionView.contentInset.left + collectionView.contentInset.right
        let maxWidth = collectionView.bounds.width - insetHorizontal
        
        if itemSize.width + extraWidth > maxWidth {
            return CGSize(width: maxWidth, height: Size.addCollectionViewHeight)
        }
        return CGSize(width: itemSize.width + extraWidth,
                      height: Size.addCollectionViewHeight)
    }
}
