//
//  CardsStorage.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class CardsStorage: NSObject {
    
    //MARK: Properties
    var name: String
    private lazy var cards: [Card] = self.cardsFromFile()
    
    
    //MARK: Lyfecycle
    init(fileName: String) {
        name = fileName
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
    private func cardsFromFile() -> [Card]{
        return arrayFromContentsOfFile()
    }
    
    private func arrayFromContentsOfFile() -> [Card] {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt") else {
            return [Card]()
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            return cardsFromStrings(content.componentsSeparatedByString("\n\n"))
        } catch _ as NSError {
            return [Card]()
        }
    }
    
    private func cardsFromStrings(strings: [String]) -> [Card] {
        var cds = [Card]()
        for strCard in strings {
            let comp = strCard.componentsSeparatedByString(" -- ")
            if comp.count == 2 {
                cds.append(Card(rus: comp[1], eng: comp[0]))
            }
        }
        return cds
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
