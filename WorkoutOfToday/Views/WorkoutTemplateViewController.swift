//
//  WorkoutTemplateCollectionViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/06/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import RealmSwift
import SwiftIcons

class WorkoutTemplateViewController: BasicViewController {

    // MARK: View
    
    weak var collectionView: UICollectionView!
    
    weak var headerLabel: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderLabel()
        setupCollectionView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
    }
    
    override func setupFeedbackGenerator() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }
    
    private func setupHeaderLabel() {
        let headerLabel = UILabel()
        headerLabel.font = .boldTitle
        headerLabel.textColor = .defaultTextColor
        
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(25)
        }
        self.headerLabel = headerLabel
    }
    
    private func setupCollectionView() {
        let layout = FeedCollectionViewFlowLayout(minimumInteritemSpacing: 3,
                                                  minimumLineSpacing: 0,
                                                  sectionInset: .zero)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(containerViewDidTapped(_:)))
        
        collectionView.addGestureRecognizer(tapGestureRecognizer)
        collectionView.contentInset.bottom = 40
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(LabelCollectionViewCell.self)
        collectionView.registerForHeaderView(TodayAddWorkoutCollectionHeaderView.self)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        self.collectionView = collectionView
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
