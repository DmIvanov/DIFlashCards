//
//  SettingsCoordinator.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 27/11/2019.
//

import UIKit

class SettingsCoordinator {

    // MARK: - Properties
    
    private let styleManager: StyleManager
    private var navigationController: UINavigationController!
    
    // MARK: - Lifecycle
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    // MARK: - Public
    
    func start(closeButton: UIBarButtonItem) -> UIViewController {
        //let rootVC = settingsListVC()
        let rootVC = LayoutSettingsVC(styleManager: styleManager)
        
        rootVC.navigationItem.leftBarButtonItem = closeButton
        navigationController = styleManager.currentColorScheme.customNavigationController(rootVC: rootVC)
        return navigationController
    }
    
    // MARK: - Private
    
    private func settingsListVC() -> UIViewController {
        let dataSource = SettingsListDataSource()
        dataSource.delegate = self
        let vc = ListTV(styleManager: styleManager)
        vc.dataSource = dataSource
        return vc
    }
    
    fileprivate func pushGeneral() {
        
    }
    
    fileprivate func pushLayout() {
        let layoutSettingsVC = LayoutSettingsVC(styleManager: styleManager)
        navigationController.pushViewController(layoutSettingsVC, animated: true)
    }
    
    @objc private func applyColorScheme() {
        let scheme = styleManager.currentColorScheme
        scheme.styleNavigationBar(navigationBar: navigationController.navigationBar)
    }
}

extension SettingsCoordinator: SettingsListDataSourceDelegate {
    func itemSelected(item: SettingsItem) {
        switch item {
        case .general:
            pushGeneral()
        case .layout:
            pushLayout()
        }
    }
}
