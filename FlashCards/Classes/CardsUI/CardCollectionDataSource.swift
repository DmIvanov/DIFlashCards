//
//  CardCollectionDataSource.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class CardCollectionDataSource {

    private(set) var englishSideUp = false
    private var presenter: CardCollectionDataSourcePresenter
    private var deck: Deck

    init(deck: Deck, presenter: CardCollectionDataSourcePresenter) {
        self.deck = deck
        self.presenter = presenter
    }

    func changeCardsSide() {
        englishSideUp = !englishSideUp
    }


    // MARK: Deck interaction

    func shuffleDeck() {
        deck.shuffle()
    }

    func deckName() -> String {
        return deck.name
    }

    func deckSize() -> Int {
        return deck.cardsAmount()
    }

    func filterContentForSearchText(searchText: String) {
        deck.filterCardsForSearchText(searchText: searchText)
    }

    func card(indexPath: IndexPath) -> Card? {
        return deck.cardForIdx((indexPath as NSIndexPath).row)
    }

    func enableFiltering(_ enable: Bool) {
        deck.filtering = enable
    }
}


protocol CardCollectionDataSourcePresenter {
    
}
