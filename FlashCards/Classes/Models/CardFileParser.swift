//
//  CardFileParser.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 27.01.16.
//
//

import UIKit

class CardFileParser: NSObject {
    
    class func arrayFromContentsOfFile(_ name: String, pathToDisplay: String) -> [Card] {
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
            return [Card]()
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return cardsFromStrings(content.components(separatedBy: "\n"), pathToDisplay: "\(pathToDisplay)\\\(name)")
        } catch _ as NSError {
            return [Card]()
        }
    }
    
    class func cardsFromStrings(_ strings: [String], pathToDisplay: String) -> [Card] {
        var cds = [Card]()
        for str in strings {
            if str == "" {continue}
            if str.hasPrefix("//") {continue}   //it's comment
            
            let comp = str.components(separatedBy: " -- ")
            if comp.count == 2 {
                let card = Card(frontString: comp[1], backString: comp[0])
                card.path = "\(pathToDisplay)"
                cds.append(card)
            }
        }
        return cds
    }

}
