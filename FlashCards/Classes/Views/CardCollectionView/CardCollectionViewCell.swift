//
//  CardCollectionViewCell.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 29/09/2019.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell  {
    
    private var frontSide = true
    
    private let originalFrontView: CardSideView
    private let originalBackView: CardSideView
    
    private var faceView: UIView {
        return frontSide ? originalFrontView : originalBackView
    }
    private var backView: UIView {
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
    
    func setUp(card: Card, styleManager: StyleManager) {
        resetLabels(card: card, styleManager: styleManager)
        setUpCorners(separateCell: styleManager.currentCardsLayout.separateItems)
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
    
    private func resetLabels(card: Card, styleManager: StyleManager) {
        originalFrontView.setUp(title: card.frontString,
                                subtitle: nil,
                                colorScheme: styleManager.currentColorScheme,
                                front: true,
                                separateView: styleManager.currentCardsLayout.separateItems)
        originalBackView.setUp(title: card.backString,
                               subtitle: card.path,
                               colorScheme: styleManager.currentColorScheme,
                               front: false,
                               separateView: styleManager.currentCardsLayout.separateItems)
    }
    
    private func setUpCorners(separateCell: Bool) {
        if separateCell {
            originalFrontView.layer.cornerRadius = 8
            originalBackView.layer.cornerRadius = 8
        } else {
            originalFrontView.layer.cornerRadius = 0
            originalBackView.layer.cornerRadius = 0
        }
    }
}
