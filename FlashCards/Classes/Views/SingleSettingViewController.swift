//
//  SingleSettingViewController.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 04/10/2019.
//

import UIKit

class SingleSettingViewController: UIViewController {
    
    private weak var delegate: SingleSettingViewControllerDelegate?
    private var collectionVC: SettingCollectionViewController!
    private let styleManager: StyleManager
    private let titleLabel = UILabel.autolayoutView()
    
    init(title: String, dataSourse: [String], delegate: SingleSettingViewControllerDelegate, styleManager: StyleManager, selectedItem: Int) {
        self.delegate = delegate
        self.styleManager = styleManager

        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        let labelWrapper = UIView.autolayoutView()
        labelWrapper.addSubview(titleLabel)
        
        collectionVC = SettingCollectionViewController(
            styleManager: styleManager,
            dataSource: dataSourse,
            delegate: self,
            selectedItem: selectedItem
        )
        addChild(collectionVC)
        collectionVC.didMove(toParent: self)
        
        let stackView = UIStackView.autolayoutView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(labelWrapper)
        stackView.addArrangedSubview(collectionVC.view)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: labelWrapper.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: labelWrapper.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: labelWrapper.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: labelWrapper.bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetColorScheme() {
        collectionVC.resetColorScheme()
        titleLabel.textColor = styleManager.currentColorScheme.navBarBackgroundColor
    }
}

extension SingleSettingViewController: SettingCollectionViewControllerDelegate {
    func itemDidSelect(index: Int, sender: SettingCollectionViewController) {
        delegate?.itemDidSelect(index: index, sender: self)
    }
}

protocol SingleSettingViewControllerDelegate: AnyObject {
    func itemDidSelect(index: Int, sender: SingleSettingViewController)
}
