//
//  ListInteractor.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class ListInteractor {

    var mainNC: UINavigationController!
    var mainInteractor: AppInteractor
    let storage = GroupsStorage()

    init(interactor: AppInteractor) {
        self.mainInteractor = interactor
        let firstVC = AppScreenFactory().listVC()
        firstVC.dataSource = GroupsDataSource(interactor: self)
        mainNC = UINavigationController(rootViewController: firstVC)
    }

    func listRootVC() -> UIViewController {
        return mainNC;
    }

    func initialDeck() -> Deck? {
        return storage.defaultDeck()
    }

    func deckWasChosen(_ deck: Deck) {
        mainInteractor.deckWasChosen(deck)
    }

    func pushNewGroup(_ group: GroupOfDecks) {
        let vc = AppScreenFactory().listVC()
        vc.dataSource = DecksDataSource(group: group, interactor: self)
        mainNC.pushViewController(vc, animated: true)
    }
}
