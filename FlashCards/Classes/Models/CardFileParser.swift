//
//  CardFileParser.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 27.01.16.
//
//

import Foundation

struct RetrievedResult {
    let decks: [Deck]
    let allCards: [Card]
}

class CardFileParser {
    func parsCardFileContent(content: String, deckName: String) -> [Card] {
        var cards = [Card]()
        let lines = content.components(separatedBy: "\n")
        for str in lines {
            if str == "" { continue }
            if str.hasPrefix("//") { continue }   //it's comment
            
            let comp = str.components(separatedBy: " -- ")
            if comp.count == 2 {
                let card = Card(frontString: comp[1], backString: comp[0])
                card.path = deckName
                cards.append(card)
            }
        }
        return cards
    }
}

class BundleRetriever {
    
    private let exampleDecks = ["English Idioms", "Spanish phrases"]
    
    func decksFromBundle(cardParser: CardFileParser) -> RetrievedResult {
        var decks = [Deck]()
        var allCards = [Card]()
        for name in exampleDecks {
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                // error
                continue
            }
            guard let content = try? String(contentsOfFile:path, encoding: String.Encoding.utf8) else {
                // error
                continue
            }
            let cards = cardParser.parsCardFileContent(content: content, deckName: name)
            
            allCards.append(contentsOf: cards)
            decks.append(Deck(name: name, cards: cards))
        }
        return RetrievedResult(decks: decks, allCards: allCards)
    }
}

class FileSystemRetriever {
    
    private let ext = "txt"
        
    func decksFromDocuments(cardParser: CardFileParser) -> RetrievedResult {
        var decks = [Deck]()
        var allCards = [Card]()
        for fileURL in directoryContent().filter({ $0.pathExtension == ext }) {
            guard let content = try? String(contentsOf: fileURL) else {
                // error
                continue
            }
            let deckName = fileURL.lastPathComponent.replacingOccurrences(of: ".\(ext)", with: "")
            let cards = cardParser.parsCardFileContent(content: content, deckName: deckName)
            
            allCards.append(contentsOf: cards)
            decks.append(Deck(name: deckName, cards: cards))
        }
        return RetrievedResult(decks: decks, allCards: allCards)
    }
    
    func structureConfigFromDocuments() -> [String : [String]]? {
        let jsons = directoryContent().filter { (url) -> Bool in
            return url.pathExtension == "json" && url.absoluteString == "structure"
        }
        guard let url = jsons.first else { return nil }
        guard let content = try? Data(contentsOf: url) else { return nil }
        guard let jsonDict = try? JSONSerialization.jsonObject(with: content) as? [String : [String]] else { return nil }
        return jsonDict
        
        /*
        guard let url = Bundle.main.url(forResource: "structure", withExtension: "json") else {
            // error
            return nil
        }
        guard let content = try? Data(contentsOf: url) else {
            // error
            return nil
        }
        guard let jsonDict = try? JSONSerialization.jsonObject(with: content) as? [String : [String]] else {
            // error
            return nil
        }
        return jsonDict
         */
    }
    
    private func directoryContent() -> [URL] {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let directoryContent = try? FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil) else {
                return [URL]()
        }
        return directoryContent
    }
}
