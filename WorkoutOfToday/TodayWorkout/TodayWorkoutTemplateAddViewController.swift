//
//  TodayWorkoutTemplateAddViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/05/14.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

import SwiftIcons

class TodayWorkoutTemplateAddViewController: BasicViewController {
    
    // MARK: Model
    
    private var parts: [Part] = {
        let parts = Part.allCases.filter { $0.name != "-" }
        return parts
    }()
    
    private var styles: [Style] = {
        let styles = Style.allCases.filter { $0 != .none}
        return styles
    }()
    
    var delegate: AddWorkoutTemplate?
    
    // MARK: View
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var subtitleLabels: [UILabel]!
    
    @IBOutlet weak var templateNameTextField: FormTextField!
    
    @IBOutlet weak var templateAttributesCollectionView: UICollectionView!
    
    @IBOutlet weak var templateAddButton: BasicButton!
    
    @IBOutlet weak var templateStyleSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupSegmentedControl()
        setupCollectionView()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        templateNameTextField.becomeFirstResponder()
    }
    
    override func keyboardWillShow(in bounds: CGRect?) {
        guard let bounds = bounds else { return }
        let overlappedHeight = view.frame.maxY - bounds.minY
        let extraHeight: CGFloat = 5
        let move = overlappedHeight + extraHeight
        self.moved = move
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= move
        }
    }
    
    override func keyboardWillHide() {
        guard let moved = moved else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += moved
        }
    }
    
    override func setupFeedbackGenerator() {
        notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator?.prepare()
        
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }
    
    private func setupSubViews() {
        titleLabel.text = "템플릿 추가"
        titleLabel.font = .smallBoldTitle
        titleLabel.textColor = .defaultTextColor
        
        let subtitles = ["이름", "파트", "스타일"]
        for (index, subtitleLabel) in subtitleLabels.enumerated() {
            subtitleLabel.text = subtitles[index]
            subtitleLabel.font = .boldBody
            subtitleLabel.textColor = .defaultTextColor
        }
        
        
        templateNameTextField.font = .smallBoldTitle
        templateNameTextField.textAlignment = .left
        templateNameTextField.placeholder = "운동 템플릿 이름"
        templateNameTextField.delegate = self
        
        templateAddButton.setTitle("확인", for: .normal)
        templateAddButton.setTitleColor(.white, for: .normal)
        templateAddButton.titleLabel?.font = .smallestBoldTitle
        templateAddButton.backgroundColor = .tintColor
        templateAddButton.addTarget(self, action: #selector(templateAddButtonDidTapped(_:)), for: .touchUpInside)
    }
    
    private func setupSegmentedControl() {
        templateStyleSegementedControl.selectedSegmentIndex = 0
        templateStyleSegementedControl.layer.cornerRadius = 5.0
        templateStyleSegementedControl.backgroundColor = .white
        templateStyleSegementedControl.tintColor = .white
        
        // TODO: change to all versions
        if #available(iOS 13.0, *) {
            templateStyleSegementedControl.selectedSegmentTintColor = .tintColor
            templateStyleSegementedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ],
                for: .selected
            )
            templateStyleSegementedControl.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: UIColor.tintColor,
                    NSAttributedString.Key.font: UIFont.boldBody
                ],
                for: .normal
            )
        }
    }
    
    private func setupCollectionView() {
        if let layout = templateAttributesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 8
            layout.itemSize = CGSize(width: 55, height: 55)
        }
        
        templateAttributesCollectionView.allowsMultipleSelection = true
        templateAttributesCollectionView.delaysContentTouches = false
        templateAttributesCollectionView.showsHorizontalScrollIndicator = false
        
        templateAttributesCollectionView.delegate = self
        templateAttributesCollectionView.dataSource = self
        templateAttributesCollectionView.register(CircularLabelCollectionViewCell.self)
    }
}

// MARK: objc functions

extension TodayWorkoutTemplateAddViewController {
    @objc
    private func templateAddButtonDidTapped(_ sender: UIButton) {
        let newWorkoutTemplate = WorkoutTemplate()
        
        guard let name = templateNameTextField.text, name != "" else {
            templateNameTextField.backgroundColor = Part.chest.color.withAlphaComponent(0.5)
            notificationFeedbackGenerator?.notificationOccurred(.error)
            return
        }
        
        guard let selectedIndexPaths = templateAttributesCollectionView.indexPathsForSelectedItems,
            !selectedIndexPaths.isEmpty else {
            notificationFeedbackGenerator?.notificationOccurred(.error)
            return
        }
        
        let part = parts[selectedIndexPaths[0].item]
        let style = styles[templateStyleSegementedControl.selectedSegmentIndex]
        
        newWorkoutTemplate.name = name
        newWorkoutTemplate.part = part
        newWorkoutTemplate.style = style
        DBHandler.shared.create(object: newWorkoutTemplate)
        delegate?.workoutTemplateDidAdded()
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: CollectionView Delegate

extension TodayWorkoutTemplateAddViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
            !selectedIndexPaths.isEmpty else {
            return true
        }
        
        collectionView.deselectItem(at: selectedIndexPaths[0], animated: true)
        return true
    }
}

// MARK: CollectionView Data Source

extension TodayWorkoutTemplateAddViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CircularLabelCollectionViewCell.self, for: indexPath)
        let part = parts[indexPath.item]
        cell.content = part
        cell.nameLabel.font = .boldBody
        return cell
    }
}

// MARK: TextField Delegate

extension TodayWorkoutTemplateAddViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let _ = textField.text, textField.text != "" {
            textField.backgroundColor = .concaveColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol AddWorkoutTemplate {
    func workoutTemplateDidAdded()
}
