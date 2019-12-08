//
//  AppScreenFactory.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class AppScreenFactory {
    
    private let styleManager: StyleManager
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
    }
    
    func cardsVC(deck: Deck) -> UIViewController {
        let vc = CardsVC(styleManager: styleManager)
        let cardsVCDS = CardCollectionDataSource(deck: deck)
        vc.dataSource = cardsVCDS
        return vc
    }
    
    func listVC(dataSource: DecksDataSource, rightBarButton: UIBarButtonItem) -> UIViewController {
        let vc = ListTV(styleManager: styleManager)
        vc.dataSource = dataSource
        vc.navigationItem.rightBarButtonItem = rightBarButton
        return vc
    }
}
