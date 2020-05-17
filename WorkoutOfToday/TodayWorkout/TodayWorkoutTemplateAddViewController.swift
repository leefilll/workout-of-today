//
//  TodayWorkoutTemplateAddViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class TodayWorkoutTemplateAddViewController: BaseViewController {
    
    // MARK: Model
    
    fileprivate var atttributes: [[Selectable]] = {
        let parts = Part.allCases.filter { $0.name != "-" }
        let styles = Style.allCases.filter { $0.name != "-" }
        
        return [parts, styles]
    }()
    
    var delegate: AddWorkoutTemplate?
    
    // MARK: View
    
    @IBOutlet weak var titleNavigationBar: UINavigationBar!
    
    @IBOutlet weak var templateNameLabel: UILabel!
    
    @IBOutlet weak var templateNameTextField: FormTextField!
    
    @IBOutlet weak var templateAttributesCollectionView: UICollectionView!
    
    @IBOutlet weak var templateAddButton: UIButton!
    
    override func setup() {
        
        titleNavigationBar.topItem?.title = "운동 템플릿"
        titleNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        titleNavigationBar.shadowImage = UIImage()
        
        templateNameLabel.text = "이름"
        templateNameLabel.font = .subheadline
        
        templateNameTextField.font = .smallBoldTitle
        templateNameTextField.textAlignment = .left
        templateNameTextField.placeholder = "운동 이름을 입력해주세요."
        templateNameTextField.delegate = self
        
        templateAddButton.setTitle("저장", for: .normal)
        templateAddButton.setTitleColor(.white, for: .normal)
        templateAddButton.titleLabel?.font = .boldBody
        templateAddButton.backgroundColor = .tintColor
        templateAddButton.clipsToBounds = true
        templateAddButton.layer.cornerRadius = 10
        templateAddButton.addTarget(self, action: #selector(templateAddButtonDidTapped(_:)), for: .touchUpInside)
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        if let layout = templateAttributesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 10
            layout.headerReferenceSize = CGSize(width: 0, height: 40)
        }
        templateAttributesCollectionView.delegate = self
        templateAttributesCollectionView.dataSource = self
        templateAttributesCollectionView.registerForHeaderView(LabelCollectionHeaderView.self)
        templateAttributesCollectionView.register(LabelCollectionViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.backgroundColor = .white
    }
    
    fileprivate func configureCollectionView() {
        templateAttributesCollectionView.isScrollEnabled = false
        templateAttributesCollectionView.allowsMultipleSelection = true
        templateAttributesCollectionView.delaysContentTouches = false
    }
}

// MARK: objc functions

extension TodayWorkoutTemplateAddViewController {
    @objc
    fileprivate func templateAddButtonDidTapped(_ sender: UIButton) {
        let newWorkoutTemplate = WorkoutTemplate()
        
        guard let name = templateNameTextField.text, name != "" else {
            showBasicAlert(title: "알림", message: "운동 템플릿 이름을 입력해주세요.")
            return
        }
        
        guard let selectedIndex = templateAttributesCollectionView.indexPathsForSelectedItems,
            selectedIndex.count >= 2 else {
            showBasicAlert(title: "알림", message: "파트와 스타일 모두 선택해주세요.")
            return
        }
        
        newWorkoutTemplate.name = name
        selectedIndex.forEach {
            if $0.section == 0 {
                newWorkoutTemplate.part = atttributes[$0.section][$0.item] as! Part
            } else if $0.section == 1{
                newWorkoutTemplate.style = atttributes[$0.section][$0.item] as! Style
            }
        }
        
        DBHandler.shared.create(object: newWorkoutTemplate)
        delegate?.workoutTemplateDidAdded()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate

extension TodayWorkoutTemplateAddViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
            return true
        }
        
        let selectingSection = indexPath.section
        selectedIndexPaths.forEach {
            if $0.section == selectingSection {
                collectionView.deselectItem(at: $0, animated: true)
            }
        }
        return true
    }
}

// MARK: CollectionView Data Source

extension TodayWorkoutTemplateAddViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return atttributes.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return atttributes[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(LabelCollectionViewCell.self, for: indexPath)
        let attribute = atttributes[indexPath.section][indexPath.item]
        cell.content = attribute
        cell.nameLabel.font = .boldBody
        return cell
    }
    
    // MARK: Header View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView
            .dequeueReusableSupplementaryHeaderView(LabelCollectionHeaderView.self, for: indexPath)
        
        let title = atttributes[indexPath.section][indexPath.item].title
        header.titleLabel.text = title
        header.titleLabel.font = .subheadline
        header.titleLabelLeadingConstant = 5
        return header
    }
}

// MARK: CollectionView Flow Layout Delegate

extension TodayWorkoutTemplateAddViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let attribute = atttributes[indexPath.section][indexPath.item]
        let attributeString = attribute.name
        
        let fontAtttribute = [NSAttributedString.Key.font: UIFont.boldBody]
        let size = attributeString.size(withAttributes: fontAtttribute)
        
        let extraSpace: CGFloat = 20
        let width = size.width + extraSpace
        
        return CGSize(width: width, height: 35)
    }
}

// MARK: TextField Delegate

extension TodayWorkoutTemplateAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol AddWorkoutTemplate {
    func workoutTemplateDidAdded()
}
