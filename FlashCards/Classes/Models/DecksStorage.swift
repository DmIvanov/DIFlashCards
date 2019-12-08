//
//  DecksStorage.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 22/11/2019.
//

import Foundation

class DecksStorage {
    
    func decksDataSource(delegate: PlainDecksDataSourceDelegate & GroupDecksDataSourceDelegate) -> DecksDataSource {
        let cardParser = CardFileParser()
        let bundleRetriever = BundleRetriever()
        let fileSystemRetriever = FileSystemRetriever()
        
        // retrieving cards from Documents folder
        var result = fileSystemRetriever.decksFromDocuments(cardParser: cardParser)
        
        if result.allCards.count == 0 {
            // retrieving example cards from the bundel
            result = bundleRetriever.decksFromBundle(cardParser: cardParser)
        }
        
        if let groupsStructure = fileSystemRetriever.structureConfigFromDocuments() {
            return groupDataSource(groupsStructure: groupsStructure,
                                   retrievingResult: result,
                                   delegate: delegate)
        } else {
            return plainDecksDataSource(retrievingResult: result,
                                        delegate: delegate)
        }
    }
    
    private func groupDataSource(groupsStructure: [String : [String]], retrievingResult: RetrievedResult,delegate: GroupDecksDataSourceDelegate) -> GroupDecksDataSource {
        var arrayOfGroups = [GroupOfDecks]()
        //var othersGroup = [Deck]()
        
        for groupDict in groupsStructure {
            var decksInGroup = [Deck]()
            for deckName in groupDict.value {
                guard let deck = retrievingResult.decks.first(where: { $0.name == deckName }) else {
                    continue
                }
                decksInGroup.append(deck)
            }
            let group = GroupOfDecks(name: groupDict.key, decks: decksInGroup)
            arrayOfGroups.append(group)
        }
        
        let allCardsDeck = Deck(name: "All", cards: retrievingResult.allCards)
        let allCardsGroup = GroupOfDecks(name: "All", decks: [allCardsDeck])
        arrayOfGroups.append(allCardsGroup)
        
        let dataSource = GroupDecksDataSource(groups: arrayOfGroups)
        dataSource.delegate = delegate
        return dataSource
    }
    
    private func plainDecksDataSource(retrievingResult: RetrievedResult, delegate: PlainDecksDataSourceDelegate) -> PlainDecksDataSource {
        let allCardsDeck = Deck(name: "All", cards: retrievingResult.allCards)
        let allDecks = retrievingResult.decks + [allCardsDeck]
        let sortedDecks = allDecks.sorted(by: { $0.name < $1.name })
        
        let dataSource = PlainDecksDataSource(name: "Cards", decks: sortedDecks)
        dataSource.delegate = delegate
        return dataSource
    }
}
