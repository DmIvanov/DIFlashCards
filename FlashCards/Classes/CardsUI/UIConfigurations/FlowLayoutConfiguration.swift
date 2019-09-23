//
//  FlowLayoutConfiguration.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 24/08/2019.
//

import UIKit

struct FlowLayoutConfiguration {
    
    let sideItemScale: CGFloat
    let sideItemShift: CGFloat
    let sideItemAlpha: CGFloat
    let direction: UICollectionView.ScrollDirection
    let spacingMode: FlowLayoutSpacingMode
    let turnAnimationOptions: UIView.AnimationOptions
    let turnAnimationDuration: TimeInterval
    
    let cardConfiguration: CardCollectionViewCellConfiguration
    
    static let configuration_1 = FlowLayoutConfiguration(
        sideItemScale: 0.6,
        sideItemShift: 0.0,
        sideItemAlpha: 0.2,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.overlap(visibleOffset: 0),
        turnAnimationOptions: [UIView.AnimationOptions.transitionFlipFromLeft],
        turnAnimationDuration: 0.3,
        cardConfiguration: CardCollectionViewCellConfiguration.configuration_1
    )
    
    static let configuration_2 = FlowLayoutConfiguration(
        sideItemScale: 0.6,
        sideItemShift: 0.0,
        sideItemAlpha: 0.2,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.fixed(spacing: 10),
        turnAnimationOptions: [UIView.AnimationOptions.transitionFlipFromLeft],
        turnAnimationDuration: 0.3,
        cardConfiguration: CardCollectionViewCellConfiguration.configuration_1
    )
}
