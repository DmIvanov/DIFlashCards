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
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = colorScheme.navBarBackgroundColor
        navigationController.navigationBar.tintColor = colorScheme.navBarTextColor
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor: colorScheme.navBarTextColor
        ]
        
        return navigationController
    }
    
    func cardVCWrapped(deck: Deck) -> UINavigationController {
        let cardsVC = CardCollectionViewController(styleManager: styleManager)
        let cardsVCDS = CardCollectionDataSource(
            deck: deck,
            presenter: cardsVC
        )
        cardsVC.dataSource = cardsVCDS
        return  customNavigationController(rootVC: cardsVC)
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
    
    func settingdVC(leftBarButton: UIBarButtonItem) -> UIViewController {
        let settingsVC = SettingsVC(styleManager: styleManager)
        settingsVC.navigationItem.leftBarButtonItem = leftBarButton
        return customNavigationController(rootVC: settingsVC)
    }
}
