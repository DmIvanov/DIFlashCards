//
//  CardCollectionViewCell.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 29/09/2019.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell  {
    
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
