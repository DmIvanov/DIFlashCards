//
//  CardCollectionDataSource.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class CardCollectionDataSource {

    private(set) var frontSide = false
    private var deck: Deck

    init(deck: Deck) {
        self.deck = deck
    }

    func changeCardsSide() {
        frontSide.toggle()
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
