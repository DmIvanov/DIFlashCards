//
//  AppScreenFactory.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class AppScreenFactory {
    
    static func customNavigationController(rootVC: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = ColorScheme.currentScheme.navBarBackgroundColor
        navigationController.navigationBar.tintColor = ColorScheme.currentScheme.navBarTextColor
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor: ColorScheme.currentScheme.navBarTextColor
        ]
        
        return navigationController
    }
    
    static func cardVCWrapped(deck: Deck) -> UINavigationController {
        let cardsVC = CardCollectionViewController()
        let cardsVCDS = CardCollectionDataSource(
            deck: deck,
            presenter: cardsVC
        )
        cardsVC.dataSource = cardsVCDS
        return  customNavigationController(rootVC: cardsVC)
    }

    static func listVCWrapped(dataSource: ListTVDataSource, rightBarButton: UIBarButtonItem) -> UINavigationController {
        return customNavigationController(rootVC: listVC(dataSource: dataSource, rightBarButton: rightBarButton))
    }
    
    static func listVC(dataSource: ListTVDataSource, rightBarButton: UIBarButtonItem) -> ListTV {
        let vc = ListTV()
        vc.dataSource = dataSource
        vc.navigationItem.rightBarButtonItem = rightBarButton
        return vc
    }
    
    static func settingdVC(leftBarButton: UIBarButtonItem) -> UIViewController {
        let settingsVC = SettingsVC()
        settingsVC.navigationItem.leftBarButtonItem = leftBarButton
        return customNavigationController(rootVC: settingsVC)
    }
}
