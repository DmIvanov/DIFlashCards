//
//  CardCollectionViewController.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 21/08/2019.
//

import UIKit

private let reuseIdentifier = "Cell"

class CardCollectionViewController: UICollectionViewController {
    
    private let configuration: FlowLayoutConfiguration = FlowLayoutConfiguration.configuration_1
    private let styleManager: StyleManager
    
    var dataSource: CardCollectionDataSource!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return styleManager.currentColorScheme.statusBarStyle
    }
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        let layout = CardsFlowLayout(config: configuration)
        super.init(collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        automaticallyAdjustsScrollViewInsets = false
        collectionView?.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        edgesForExtendedLayout = []
        
        applyColorScheme()
    }
    
    // MARK: - Public
    
    func showNextCard() {
        guard let currentItemIndexPath = currentCardIndexPath() else { return }
        let nextItem = currentItemIndexPath.item + 1
        guard nextItem < dataSource.deckSize() else { return }
        let nextElementIndexPath = IndexPath(item: nextItem, section: currentItemIndexPath.section)
        collectionView.scrollToItem(at: nextElementIndexPath, at: .centeredVertically, animated: true)
    }

    func showPreviousCard() {
        guard let currentItemIndexPath = currentCardIndexPath() else { return }
        let prevItem = currentItemIndexPath.item - 1
        guard prevItem >= 0 else { return }
        let prevElementIndexPath = IndexPath(item: prevItem, section: currentItemIndexPath.section)
        collectionView.scrollToItem(at: prevElementIndexPath, at: .centeredVertically, animated: true)
    }
    
    // MARK: - Private
    
    private func currentCardIndexPath() -> IndexPath? {
        let centralCell = collectionView.visibleCells[collectionView.visibleCells.count/2]
        return collectionView.indexPath(for: centralCell)
    }
    
    @objc private func applyColorScheme() {
        collectionView?.backgroundColor = styleManager.currentColorScheme.collectionBackground
        collectionView?.reloadData()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.deckSize()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        let card = dataSource.card(indexPath: indexPath)!
        cell.setUp(card: card, colorScheme: styleManager.currentColorScheme)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.turn(
            animationOptions: [],
            duration: 0.3
        )
    }
}

class CardCollectionViewCell: UICollectionViewCell  {
    
    var card: Card!
    var frontSide = true
    
    let originalFrontView: CardSideView
    let originalBackView: CardSideView
    
    var faceView: UIView {
        return frontSide ? originalFrontView : originalBackView
    }
    var backView: UIView {
        return frontSide ? originalBackView : originalFrontView
    }
    
    override init(frame: CGRect) {
        originalFrontView = CardSideView()
        originalBackView = CardSideView()

        super.init(frame: frame)
        
        resetFrontBack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(card: Card, colorScheme: ColorScheme) {
        self.card = card
        resetLabels(colorScheme: colorScheme)
    }
    
    func turn(animationOptions: UIView.AnimationOptions, duration: TimeInterval) {
        UIView.transition(from: faceView,
                          to: backView,
                          duration: duration,
                          options: [UIView.AnimationOptions.transitionFlipFromLeft]) { (completed) in
                            self.pinSubviewToEdges(subview: self.faceView, position: 0)
                            self.frontSide.toggle()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetFrontBack()
    }
    
    private func resetFrontBack() {
        frontSide = true
        for subview in subviews {
            subview.removeFromSuperview()
        }

        pinSubviewToEdges(subview: originalFrontView)
        pinSubviewToEdges(subview: originalBackView)
    }
    
    private func resetLabels(colorScheme: ColorScheme) {
        originalFrontView.setUp(
            title: card.frontString,
            subtitle: nil,
            colorScheme: colorScheme,
            front: true
        )
        originalBackView.setUp(
            title: card.backString,
            subtitle: card.path,
            colorScheme: colorScheme,
            front: false
        )
    }
}

final class CardSideView: UIView {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pinSubviewToEdges(subview: label, inset: 10)
        label.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(title: String, subtitle: String?, colorScheme: ColorScheme, front: Bool) {
        backgroundColor = front ? colorScheme.cardFrontBackgroundColor : colorScheme.cardBackBackgroundColor
        setUpContent(titleString: title, subtitleString: subtitle, colorScheme: colorScheme, front: front)
    }
    
    private func setUpContent(titleString: String, subtitleString: String?, colorScheme: ColorScheme, front: Bool) {
        let titleColor = front ? colorScheme.cardFrontTextColor : colorScheme.cardBackTextColor
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 26.0)!,
            NSAttributedString.Key.foregroundColor: titleColor
        ]
        let title = NSMutableAttributedString(string: titleString, attributes: titleAttributes)
        let subtitleColor = front ? colorScheme.cardFrontTextColor2 : colorScheme.cardBackTextColor2
        if let sub = subtitleString {
            let subtitleAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 12.0)!,
                NSAttributedString.Key.foregroundColor: subtitleColor
            ]
            let gap = NSAttributedString(string: "\n\n")
            let subtitle = NSAttributedString(string: sub, attributes: subtitleAttributes)
            title.append(gap)
            title.append(subtitle)
        }
        label.attributedText = title
    }
}
