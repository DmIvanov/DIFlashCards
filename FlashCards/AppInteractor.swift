//
//  AppInteractor.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit;

class AppInteractor {

    // MARK: - Properties
    
    private var presenter: AppPresenter!
    private var screenFactory: AppScreenFactory!
    
    // MARK: -  Lifecycle
    
    init(screenFactory: AppScreenFactory? = nil) {
        let groupDataSource = GroupsDataSource()
        let styleManager = StyleManager()
        self.screenFactory = screenFactory ?? AppScreenFactory(styleManager: styleManager)
        let listNavigationController = self.screenFactory.listVC(
            dataSource: groupDataSource,
            rightBarButton: settingsBarButtonItem()
        )
        let cardsNavigationController = self.screenFactory.cardsVC(deck: groupDataSource.initialDeck()!)

        groupDataSource.delegate = self
        
        presenter = AppPresenter(
            masterContentVC: listNavigationController,
            detailContentVC: cardsNavigationController,
            styleManager: styleManager)
    }
    
    // MARK: - Public

    func appDidLaunch(options: [UIApplication.LaunchOptionsKey : Any]?, window: UIWindow?) {
        window?.rootViewController = presenter.rootVC()
    }

    func pushNewDeck(deck: Deck) {
        let newCardsVC = screenFactory.cardsVC(deck: deck)
        presenter.pushNewDetailVC(detailContentVC: newCardsVC)
    }
    
    func pushNewGroup(group: GroupOfDecks) {
        let newGroupVC = screenFactory.listVC(
            dataSource: DecksDataSource(group: group, delegate: self),
            rightBarButton: settingsBarButtonItem()
        )
        presenter.pushNewMasterVC(masterContentVC: newGroupVC)
    }
    
    // MARK: - Private
    
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
        let settingsNavigationController = screenFactory.settingsVC(leftBarButton: settingsCloseButtonItem())
        presenter.present(viewController: settingsNavigationController)
    }
    
    @objc private func settingsCloseButtonPressed() {
        presenter.dismissCurrentlyPresentingVC()
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
