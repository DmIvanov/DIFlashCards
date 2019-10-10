//
//  FlowLayoutConfiguration.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 24/08/2019.
//

import UIKit

struct FlowLayoutConfiguration {
    
    enum FlowLayoutConfigurationType: String, CaseIterable {
        case separated = "Separated"
        case scaled = "Scaled"
        case list = "List"
    }
    
    let type: FlowLayoutConfigurationType
    let sideItemScale: CGFloat
    let sideItemShift: CGFloat
    let sideItemAlpha: CGFloat
    let direction: UICollectionView.ScrollDirection
    let spacingMode: FlowLayoutSpacingMode
    let turnAnimationDuration: TimeInterval
    
    static var defaultConfiguration = FlowLayoutConfiguration.separated
    
    static func configuration(type: FlowLayoutConfigurationType) -> FlowLayoutConfiguration {
        switch type {
        case .separated: return separated
        case .scaled: return scaled
        case .list: return list
        }
    }
    
    static let separated = FlowLayoutConfiguration(
        type: .separated,
        sideItemScale: 0.6,
        sideItemShift: 0.0,
        sideItemAlpha: 0.2,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.overlap(visibleOffset: 0),
        turnAnimationDuration: 0.3
    )
    
    static let scaled = FlowLayoutConfiguration(
        type: .scaled,
        sideItemScale: 0.6,
        sideItemShift: 0.0,
        sideItemAlpha: 0.2,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.fixed(spacing: 0),
        turnAnimationDuration: 0.3
    )
    
    static let list = FlowLayoutConfiguration(
        type: .list,
        sideItemScale: 1.0,
        sideItemShift: 0.0,
        sideItemAlpha: 0.4,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.fixed(spacing: 0),
        turnAnimationDuration: 0.3
    )
}
