//
//  CardFileParser.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 27.01.16.
//
//

import UIKit

class CardFileParser: NSObject {
    
    class func arrayFromContentsOfFile(name: String) -> [Card] {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt") else {
            return [Card]()
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            return cardsFromStrings(content.componentsSeparatedByString("\n"))
        } catch _ as NSError {
            return [Card]()
        }
    }
    
    class func cardsFromStrings(strings: [String]) -> [Card] {
        var cds = [Card]()
        for str in strings {
            if str == "" {continue}
            if str.hasPrefix("//") {continue}   //it's comment
            
            let comp = str.componentsSeparatedByString(" -- ")
            if comp.count == 2 {
                cds.append(Card(rus: comp[1], eng: comp[0]))
            }
        }
        return cds
    }

}
