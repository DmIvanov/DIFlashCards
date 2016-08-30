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
    fileprivate (set) var name: String
    fileprivate (set) var cards: [Card]
    
    
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
    
    func cardForIdx(_ idx: Int) -> Card? {
        guard idx <= cards.count else {return nil}
        return cards[idx]
    }
    
    func shuffle() {
        cards = cards.shuffle()
    }
    
    
    //MARK: Private
    fileprivate class func cardsFromFile(_ name: String) -> [Card]{
        return CardFileParser.arrayFromContentsOfFile(name)
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
