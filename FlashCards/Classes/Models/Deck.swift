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
    init(name: String, path: String? = nil, cards: [Card]? = nil) {
        self.name = name
        if let cs = cards {
            self.cards = cs
        } else if path != nil {
            self.cards = Deck.cardsFromFile(name, path: path!)
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
            return card.rusString.lowercased().contains(stringToCheck) || card.engString.lowercased().contains(stringToCheck)
        }
    }
    
    
    //MARK: Private
    fileprivate class func cardsFromFile(_ name: String, path: String) -> [Card]{
        return CardFileParser.arrayFromContentsOfFile(name, pathToDisplay: path)
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
        let allCount = Int(count.toIntMax())
        if allCount < 2 { return }
        
        for i in 0..<allCount - 1 {
            let j = Int(arc4random_uniform(UInt32(allCount - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
