//
//  Heading.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class Heading: NSObject {
    
    //MARK: Properties
    private (set) var name: String
    private (set) var cards: [Card]
    
    
    //MARK: Lyfecycle
    init(name: String, cards: [Card]? = nil) {
        self.name = name
        if let cs = cards {
            self.cards = cs
        } else {
            self.cards = Heading.cardsFromFile(name)
        }
    }
    
    
    //MARK: TableView dataSource
    func cardsNumber() -> Int {
        return cards.count
    }
    
    func cardForIdx(idx: Int) -> Card? {
        guard idx <= cards.count else {return nil}
        return cards[idx]
    }
    
    func shuffle() {
        cards = cards.shuffle()
    }
    
    
    //MARK: Private
    private class func cardsFromFile(name: String) -> [Card]{
        return CardFileParser.arrayFromContentsOfFile(name)
    }
}


extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
