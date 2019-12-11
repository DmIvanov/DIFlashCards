//
//  FlowLayoutConfiguration.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 24/08/2019.
//

import UIKit

enum FlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}

struct FlowLayoutConfiguration {
    
    enum FlowLayoutConfigurationType: String, CaseIterable {
        case separated = "Separated"
        case scaled = "Scaled"
        case list = "List"
    }
    
    let type: FlowLayoutConfigurationType
    let minItemScale: CGFloat
    let maxItemScale: CGFloat
    let itemShift: CGFloat
    let itemAlpha: CGFloat
    let direction: UICollectionView.ScrollDirection
    let spacingMode: FlowLayoutSpacingMode
    let turnAnimationDuration: TimeInterval
    let separateItems: Bool
    
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
        minItemScale: 0.6,
        maxItemScale: 0.96,
        itemShift: 0.0,
        itemAlpha: 0.2,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.overlap(visibleOffset: 0),
        turnAnimationDuration: 0.3,
        separateItems: true
    )
    
    static let scaled = FlowLayoutConfiguration(
        type: .scaled,
        minItemScale: 0.6,
        maxItemScale: 0.96,
        itemShift: 0.0,
        itemAlpha: 0.2,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.fixed(spacing: 0),
        turnAnimationDuration: 0.3,
        separateItems: true
    )
    
    static let list = FlowLayoutConfiguration(
        type: .list,
        minItemScale: 1.0,
        maxItemScale: 1.0,
        itemShift: 0.0,
        itemAlpha: 0.4,
        direction: .vertical,
        spacingMode: FlowLayoutSpacingMode.fixed(spacing: 0),
        turnAnimationDuration: 0.3,
        separateItems: false
    )
}
