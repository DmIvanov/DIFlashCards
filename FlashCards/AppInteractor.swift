//
//  AppInteractor.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit;

class AppInteractor {

    var splitVC: UISplitViewController!
    var listInteractor: ListInteractor!

    func appDidLaunch(options: [UIApplicationLaunchOptionsKey : Any]?, rootVC: UIViewController?) {
        splitVC = rootVC as! UISplitViewController
        listInteractor = ListInteractor(interactor: self)
        let vc = cardsVC(deck: listInteractor.initialDeck()!)
        splitVC.viewControllers = [
            listInteractor.listRootVC(),
            vc
        ]
    }

    func deckWasChosen(_ deck: Deck) {
        let vc = cardsVC(deck: deck)
        splitVC.showDetailViewController(vc, sender: nil)
    }

    private func cardsVC(deck: Deck) -> UIViewController {
        let cardsVC = AppScreenFactory().cardVC()
        let cardsVCDS = CardTVDataSource(
            deck: deck,
            presenter: cardsVC
        )
        cardsVC.setDataSource(cardsVCDS)
        return UINavigationController(rootViewController: cardsVC) as UIViewController
    }
}
