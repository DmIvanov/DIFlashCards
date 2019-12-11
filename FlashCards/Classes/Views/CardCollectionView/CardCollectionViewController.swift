//
//  CardCollectionViewController.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 21/08/2019.
//

import UIKit

private let reuseIdentifier = "Cell"

class CardCollectionViewController: UICollectionViewController {
       
    // MARK: - Public properties
    
    var dataSource: CardCollectionDataSource!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return styleManager.currentColorScheme.statusBarStyle
    }
    
    // MARK: - Private properties
    
    private let styleManager: StyleManager
    
    // MARK: - Lifecycle
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        super.init(collectionViewLayout: CardsFlowLayout(config: styleManager.currentCardsLayout))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyCardsLayout),
            name: StyleManager.kCardsLayoutDidUpdateName,
            object: styleManager
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView?.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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
    
    func reloadData() {
        collectionView.reloadData()
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
    
    @objc private func applyCardsLayout() {
        let newLayout = CardsFlowLayout(config: styleManager.currentCardsLayout)
        collectionView.setCollectionViewLayout(newLayout, animated: true)
        
        // to call cellForRow() and restyle cell UI
        collectionView.reloadSections(IndexSet([0]))
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
        cell.setUp(card: card, styleManager: styleManager)
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
