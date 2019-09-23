//
//  AppInteractor.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit;

class AppInteractor {

    private var splitVC: UISplitViewController!
    private var listNavigationController: UINavigationController!
    
    private var settingsVC: UIViewController?

    func appDidLaunch(options: [UIApplication.LaunchOptionsKey : Any]?, window: UIWindow?) {
        let groupDataSource = GroupsDataSource()
        groupDataSource.delegate = self
        
        listNavigationController = AppScreenFactory.listVCWrapped(
            dataSource: groupDataSource,
            rightBarButton: settingsBarButtonItem()
        )
        let cardsNavigationController = AppScreenFactory.cardVCWrapped(deck: groupDataSource.initialDeck()!)
        
        splitVC = UISplitViewController(nibName: nil, bundle: nil)
        splitVC.viewControllers = [
            listNavigationController,
            cardsNavigationController
        ]
        
        window?.rootViewController = splitVC
    }

    func pushNewDeck(deck: Deck) {
        let vc = AppScreenFactory.cardVCWrapped(deck: deck)
        splitVC.showDetailViewController(vc, sender: nil)
    }
    
    func pushNewGroup(group: GroupOfDecks) {
        let vc = AppScreenFactory.listVC(
            dataSource: DecksDataSource(group: group, delegate: self),
            rightBarButton: settingsBarButtonItem()
        )
        listNavigationController.pushViewController(vc, animated: true)
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
        let vc = AppScreenFactory.settingdVC(leftBarButton: settingsCloseButtonItem())
        splitVC.present(
            vc,
            animated: true,
            completion: nil
        )
        settingsVC = vc
    }
    
    @objc private func settingsCloseButtonPressed() {
        settingsVC?.dismiss(animated: true, completion: nil)
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
