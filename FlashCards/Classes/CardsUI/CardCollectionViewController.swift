//
//  CardCollectionViewController.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 21/08/2019.
//

import UIKit

private let reuseIdentifier = "Cell"

class CardCollectionViewController: UICollectionViewController, CardCollectionDataSourcePresenter {
    
    let configuration: FlowLayoutConfiguration = FlowLayoutConfiguration.configuration_1
    let cardConfiguration = CardCollectionViewCellConfiguration.configuration_1
    
    var dataSource: CardCollectionDataSource!
    
    init() {
        let layout = CardsFlowLayout(config: configuration)
        super.init(collectionViewLayout: layout)
        collectionView?.backgroundColor = ColorScheme.currentScheme.collectionBackground
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.edgesForExtendedLayout = []
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
        cell.setUp(card: card, configuration: cardConfiguration)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        cell.turn(animationOptions: configuration.turnAnimationOptions, duration: configuration.turnAnimationDuration)
    }
}

class CardCollectionViewCell: UICollectionViewCell  {
    
    var card: Card!
    var configuration: CardCollectionViewCellConfiguration!
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
    
    func setUp(card: Card, configuration: CardCollectionViewCellConfiguration) {
        self.card = card
        self.configuration = configuration
        
        resetLabels()
    }
    
    func turn(animationOptions: UIView.AnimationOptions, duration: TimeInterval) {
        UIView.transition(from: faceView,
                          to: backView,
                          duration: duration,
                          options: animationOptions) { (completed) in
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
    
    private func resetLabels() {
        originalFrontView.setUp(
            title: card.frontString,
            subtitle: nil,
            bgColor: configuration.frontBackgroundColor,
            textColor: configuration.frontTextColor
        )
        originalBackView.setUp(
            title: card.backString,
            subtitle: card.path,
            bgColor: configuration.backBackgroundColor,
            textColor: configuration.backTextColor
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
    
    func setUp(title: String, subtitle: String?, bgColor: UIColor, textColor: UIColor) {
        backgroundColor = bgColor
        label.textColor = textColor
        setUpContent(title: title, subtitle: subtitle)
    }
    
    private func setUpContent(title: String, subtitle: String?) {
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 26.0)!
        ]
        let title = NSMutableAttributedString(string: title, attributes: titleAttributes)
        if let sub = subtitle {
            let subtitleAttributes = [
                NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
            let gap = NSAttributedString(string: "\n\n")
            let subtitle = NSAttributedString(string: sub, attributes: subtitleAttributes)
            title.append(gap)
            title.append(subtitle)
        }
        label.attributedText = title
    }
}
