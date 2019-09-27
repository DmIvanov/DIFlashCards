//
//  AppScreenFactory.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class AppScreenFactory {
    
    let styleManager: StyleManager
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
    }
    
    func customNavigationController(rootVC: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        let colorScheme = styleManager.currentColorScheme
        styleNavigationBar(navigationBar: navigationController.navigationBar, colorScheme: colorScheme)
        return navigationController
    }
    
    func cardVCWrapped(deck: Deck) -> UINavigationController {
        let vc = CardsVC(styleManager: styleManager)
        let cardsVCDS = CardCollectionDataSource(deck: deck)
        vc.dataSource = cardsVCDS
        return  customNavigationController(rootVC: vc)
    }

    func listVCWrapped(dataSource: ListTVDataSource, rightBarButton: UIBarButtonItem) -> UINavigationController {
        let vc = listVC(dataSource: dataSource, rightBarButton: rightBarButton)
        return customNavigationController(rootVC: vc)
    }
    
    func listVC(dataSource: ListTVDataSource, rightBarButton: UIBarButtonItem) -> ListTV {
        let vc = ListTV(styleManager: styleManager)
        vc.dataSource = dataSource
        vc.navigationItem.rightBarButtonItem = rightBarButton
        return vc
    }
    
    func settingsNavigationVC(leftBarButton: UIBarButtonItem) -> UINavigationController {
        let settingsVC = SettingsVC(styleManager: styleManager)
        settingsVC.navigationItem.leftBarButtonItem = leftBarButton
        return customNavigationController(rootVC: settingsVC)
    }
    
    func styleNavigationBar(navigationBar: UINavigationBar?, colorScheme: ColorScheme) {
        navigationBar?.isTranslucent = false
        navigationBar?.barTintColor = colorScheme.navBarBackgroundColor
        navigationBar?.tintColor = colorScheme.navBarTextColor
        navigationBar?.shadowImage = UIImage()
        navigationBar?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: colorScheme.navBarTextColor
        ]
        
        navigationBar?.layer.masksToBounds = false
        navigationBar?.layer.shadowColor = colorScheme.navBarTextColor.cgColor
        navigationBar?.layer.shadowOpacity = 0.8
        navigationBar?.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }
}
