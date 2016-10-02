//
//  HeadingsStorage.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 24.01.16.
//
//

import UIKit

class HeadingsStorage: NSObject {
    
    //MARK: Properties
    fileprivate lazy var headings: [Heading] = self.headingsFromDisk()
    let files = [
        "AdjAntonyms",
        "Animals",
        "Coloquial phrases",
        "Crime",
        "Expressions",
        "Find a job",
        "Food",
        "Idioms",
        "Medicine",
        "Money",
        "Person",
        "Phrasal Verbs",
        "Prepositions"
    ]

    
    //MARK: TableView dataSource
    func headingsNumber() -> Int {
        return headings.count
    }
    
    func headingForIdx(_ idx: Int) -> Heading? {
        guard idx <= headings.count else {return nil}
        return headings[idx]
    }
    
    
    //MARK: Private
    fileprivate func headingsFromDisk() -> [Heading] {
        var arr = [Heading]()
        var allCards = [Card]()
        for name in files {
            let heading = Heading(name: name)
            arr.append(heading)
            allCards.append(contentsOf: heading.cards)
        }
        arr.append(Heading(name: "All", cards: allCards))
        return arr
    }
}
