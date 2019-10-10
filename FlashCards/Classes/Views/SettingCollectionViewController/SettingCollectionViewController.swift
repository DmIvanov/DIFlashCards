//
//  SettingCollectionViewController.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 29/09/2019.
//

import UIKit

private let reuseIdentifier = "Cell"

class SettingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private weak var delegate: SettingCollectionViewControllerDelegate?
    private let dataSource: [String]
    private let styleManager: StyleManager
    private var selectedItem: Int
    
    var itemFont: UIFont = UIFont.systemFont(ofSize: 16)
    var itemTextColor: UIColor = UIColor.black
    
    init(styleManager: StyleManager, dataSource: [String], delegate: SettingCollectionViewControllerDelegate, selectedItem: Int) {
        self.styleManager = styleManager
        self.dataSource = dataSource
        self.delegate = delegate
        self.selectedItem = selectedItem
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
                
        collectionView.showsHorizontalScrollIndicator = false
        collectionView!.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeSelectedItemVisible(animated: true)
    }
    
    // MARK: - Public

    func resetColorScheme() {
        let scheme = styleManager.currentColorScheme
        view.backgroundColor = scheme.navBarBackgroundColor
        itemTextColor = scheme.navBarTextColor
        reloadData()
    }
    
    // MARK: - Private
    
    private func reloadData() {
        collectionView.reloadData()
    }
    
    private func makeSelectedItemVisible(animated: Bool) {
        let visibleIndexes = collectionView.indexPathsForVisibleItems.map { (indexPath) -> Int in
            return indexPath.item
        }
        if selectedItem < visibleIndexes.first! {
            collectionView.scrollToItem(at: IndexPath(item: selectedItem, section: 0),
                                        at: .left,
                                        animated: animated)
        } else {
            collectionView.scrollToItem(at: IndexPath(item: selectedItem, section: 0),
                                        at: .right,
                                        animated: animated)
        }
    }

    // MARK: UICollectionViewDataSource & UICollectionViewDelegate

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> SettingCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SettingCollectionViewCell
        let item = dataSource[indexPath.item]
        let selected = indexPath.item == selectedItem
        cell.setUp(item: item, font: itemFont, colorScheme: styleManager.currentColorScheme, selected: selected)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemDidSelect(index: indexPath.item, sender: self)
        var pathesToReload = [IndexPath]()
        pathesToReload.append(IndexPath(item: selectedItem, section: 0))
        selectedItem = indexPath.item
        pathesToReload.append(IndexPath(item: selectedItem, section: 0))
        collectionView.reloadItems(at: pathesToReload)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath.item]
        let string = NSAttributedString(
            string: item,
            attributes: [
                NSAttributedString.Key.font: itemFont,
            ])
        let labelRect = string.boundingRect(
            with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            context: nil
        )
        return CGSize(
            width: labelRect.size.width + SettingCollectionViewCell.layoutItemLabelInset * 2 + SettingCollectionViewCell.layoutItemLabelExtraWidth,
            height: labelRect.size.height + SettingCollectionViewCell.layoutItemLabelInset * 2)
    }
}

protocol SettingCollectionViewControllerDelegate: AnyObject {
    func itemDidSelect(index: Int, sender: SettingCollectionViewController)
}


final class SettingCollectionViewCell: UICollectionViewCell {
    
    static let layoutItemLabelInset: CGFloat = 4
    static let layoutItemLabelExtraWidth: CGFloat = 2
    
    private let titleLabel: UILabel
    
    override init(frame: CGRect) {
        titleLabel = UILabel.autolayoutView()
        super.init(frame: frame)
        contentView.pinSubviewToEdges(subview: titleLabel, inset: SettingCollectionViewCell.layoutItemLabelInset)
        contentView.layer.cornerRadius = SettingCollectionViewCell.layoutItemLabelInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(item: String, font: UIFont, colorScheme: ColorScheme, selected: Bool) {
        titleLabel.text = item
        titleLabel.font = font
        if selected {
            contentView.backgroundColor = colorScheme.navBarTextColor
            titleLabel.textColor = colorScheme.navBarBackgroundColor
        } else {
            titleLabel.textColor = colorScheme.navBarTextColor
            contentView.backgroundColor = colorScheme.navBarBackgroundColor
        }
    }
}
