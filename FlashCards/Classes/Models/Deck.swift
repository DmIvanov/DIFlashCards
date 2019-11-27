//
//  Heading.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import Foundation


class Deck {
    
    //MARK: Properties
    var filtering = false
    
    private (set) var name: String
    private (set) var cards: [Card]
    private (set) var filteredCards = [Card]()
    
    
    //MARK: Lyfecycle
    init(name: String, cards: [Card]? = nil) {
        self.name = name
        if let cs = cards {
            self.cards = cs
        } else {
            self.cards = [Card]()
        }
    }
    
    
    //MARK: TableView dataSource
    func cardsAmount() -> Int {
        if filtering {
            return filteredCards.count
        } else {
            return cards.count
        }
    }
    
    func cardForIdx(_ idx: Int) -> Card? {
        if filtering {
            guard idx < filteredCards.count else {return nil}
            return filteredCards[idx]
        } else {
            guard idx < cards.count else {return nil}
            return cards[idx]
        }
    }
    
    
    // MARK: Data set manipulations
    func shuffle() {
        cards = cards.shuffle()
    }
    
    func filterCardsForSearchText(searchText: String) {
        filteredCards = cards.filter { card in
            let stringToCheck = searchText.lowercased()
            return card.frontString.lowercased().contains(stringToCheck) || card.backString.lowercased().contains(stringToCheck)
        }
    }
}


extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}


extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        let allCount = Int(Int64(count))
        if allCount < 2 { return }
        
        for i in 0..<allCount - 1 {
            let j = Int(arc4random_uniform(UInt32(allCount - i))) + i
            guard i != j else { continue }
            self.swapAt(i, j)
        }
    }
}
