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
    private lazy var headings: [Heading] = self.headingsFromDisk()
    let files = [
        "Expressions",
        "Idioms",
        "Find a job",
        "Coloquial phrases",
        "Person",
        "AdjAntonyms",
        "Animals",
        "Phrasal Verbs",
        "Prepositions",
    ]

    
    //MARK: TableView dataSource
    func headingsNumber() -> Int {
        return headings.count
    }
    
    func headingForIdx(idx: Int) -> Heading? {
        guard idx <= headings.count else {return nil}
        return headings[idx]
    }
    
    
    //MARK: Private
    private func headingsFromDisk() -> [Heading] {
        
        func cardsFromFile(name: String) -> [Card] {
            return CardFileParser.arrayFromContentsOfFile(name)
        }
        
        /*
        do {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            if let path = paths.first {
                let content = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
            }
        } catch let error as NSError {
            print("Error while reading from disk: \(error.localizedDescription)")
        }
        */
        var arr = [Heading]()
        var allCards = [Card]()
        for name in files {
            let heading = Heading(name: name)
            arr.append(heading)
            allCards.appendContentsOf(heading.cards)
        }
        arr.append(Heading(name: "All", cards: allCards))
        return arr
    }
}
