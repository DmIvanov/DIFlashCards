//
//  AppInteractor.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit;

class AppInteractor {

    // MARK: - Properties
    
    private var splitVC: UISplitViewController!
    private var listNavigationController: UINavigationController!
    private var cardsNavigationController: UINavigationController!
    private var settingsNavigationController: UINavigationController?
    
    private let styleManager: StyleManager
    
    // MARK: - Dependencies
    
    private let screenFactory: AppScreenFactory
    
    // MARK: -  Lifecycle
    
    init(screenFactory: AppScreenFactory? = nil) {
        let styleManager = StyleManager()
        self.styleManager = styleManager
        self.screenFactory = screenFactory ?? AppScreenFactory(styleManager: styleManager)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    // MARK: - Public

    func appDidLaunch(options: [UIApplication.LaunchOptionsKey : Any]?, window: UIWindow?) {
        let groupDataSource = GroupsDataSource()
        groupDataSource.delegate = self
        
        listNavigationController = screenFactory.listVCWrapped(
            dataSource: groupDataSource,
            rightBarButton: settingsBarButtonItem()
        )
        cardsNavigationController = screenFactory.cardVCWrapped(deck: groupDataSource.initialDeck()!)
        
        splitVC = UISplitViewController(nibName: nil, bundle: nil)
        splitVC.viewControllers = [
            listNavigationController,
            cardsNavigationController
        ]
        
        window?.rootViewController = splitVC
    }

    func pushNewDeck(deck: Deck) {
        let vc = screenFactory.cardVCWrapped(deck: deck)
        splitVC.showDetailViewController(vc, sender: nil)
    }
    
    func pushNewGroup(group: GroupOfDecks) {
        let vc = screenFactory.listVC(
            dataSource: DecksDataSource(group: group, delegate: self),
            rightBarButton: settingsBarButtonItem()
        )
        listNavigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private
    
    @objc private func applyColorScheme() {
        let newScheme = styleManager.currentColorScheme
        screenFactory.styleNavigationBar(navigationBar: listNavigationController.navigationBar, colorScheme: newScheme)
        screenFactory.styleNavigationBar(navigationBar: cardsNavigationController.navigationBar, colorScheme: newScheme)
        screenFactory.styleNavigationBar(navigationBar: settingsNavigationController?.navigationBar, colorScheme: newScheme)
    }
    
    private func settingsBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(settingsButtonPressed)
        )
    }
    
    private func settingsCloseButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(settingsCloseButtonPressed))
    }
    
    @objc private func settingsButtonPressed() {
        let nc = screenFactory.settingsNavigationVC(leftBarButton: settingsCloseButtonItem())
        splitVC.present(nc, animated: true, completion: nil)
        settingsNavigationController = nc
    }
    
    @objc private func settingsCloseButtonPressed() {
        settingsNavigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AppInteractor: DecksDataSourceDelegate {
    func deckWasSelected(deck: Deck) {
        pushNewDeck(deck: deck)
    }
}

extension AppInteractor: GroupsDataSourceDelegate {
    func groupWasSelected(group: GroupOfDecks) {
        pushNewGroup(group: group)
    }
}
