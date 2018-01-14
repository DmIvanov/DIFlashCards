//
//  HeadingsStorage.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 24.01.16.
//
//

import UIKit

struct GroupOfDecks {
    let name: String
    let decks: [Deck]
}

class GroupsStorage: NSObject {
    
    //MARK: Properties
    fileprivate lazy var groupsOfDecks: [GroupOfDecks] = self.groupsFromDisk()
    private let groups = [
        "Topics" : [
            "_AdjAntonyms",
            "_Coloquial phrases",
            "_Idioms 1",
            "_Idioms 2",
            "_Idioms 3",
            "Animals",
            "Climate",
            "Crime",
            "House",
            "Flights",
            "Food",
            "Medicine",
            "Money",
            "Person",
            "Politics 1",
            "Politics 2",
            "Work 1",
            "Work 2"
        ],
        "Grammar" : [
            "Grammar",
            "Gerund and Infinitive",
            "GET",
            "Phrasal Verbs",
            "Prepositions 1",
            "Prepositions 2",
            "Prepositions 3",
            "Prepositions 4",
            "Prepositions 5",
            "Prepositions 6",
            "Prepositions 7",
        ],
        "Misc" : [
            "Misc01",
            "Misc02",
            "Misc03",
            "Misc04",
            "Misc05",
            "Misc06",
            "Misc07",
            "Misc08",
            "Misc09",
            "Misc10",
            "Misc11",
            "Misc12",
            "Misc13",
            "Misc14",
            "Misc15",
            "Misc16",
            "Misc17",
            "Misc18",
            "Misc19",
            "Misc20",
            "Misc21",
            "Misc22",
            "Misc23",
            "Misc24",
            "Misc25",
            "Misc26",
        ],
        "Episodes" : [
            "EC 30-39",
            "EC 40-49",
            "EC 50-59",
            "EC 60-69",
            "ESL POD 160-179",
            "Friends",
            "Harry Potter 1",
            "Harry Potter 2",
            "Harry Potter 3",
            "Games of thrones",
            "Scrubs s02e07",
            "Scurbs s02e21",
            
        ],
        "Records" : [
            "REC01. Blaze at charity bonfire",
            "REC02. Linguistic gaps",
            "REC03. News bulletin"
        ]
    ]

    
    //MARK: TableView dataSource
    func groupsAmount() -> UInt {
        return UInt(groupsOfDecks.count)
    }
    
    func decksAmountInGroup(groupIdx: UInt) -> UInt {
        guard groupIdx < UInt(groupsOfDecks.count) else {return 0}
        let decsInGroup = groupsOfDecks[Int(groupIdx)].decks
        return UInt(decsInGroup.count)
    }
    
    func groupForIdx(idx: UInt) -> GroupOfDecks? {
        guard idx < groupsAmount() else {return nil}
        return groupsOfDecks[Int(idx)]
    }

    func defaultDeck() -> Deck? {
        let group = groupsOfDecks[groupsOfDecks.count - 1]
        return group.decks.first
    }
    
    
    //MARK: Private
    fileprivate func groupsFromDisk() -> [GroupOfDecks] {
        var arrayOfGroups = [GroupOfDecks]()
        var allCards = [Card]()
        for groupDict in groups {
            var decksInGroup = [Deck]()
            for deck in groupDict.value {
                let deck = Deck(name: deck, path: groupDict.key)
                decksInGroup.append(deck)
                allCards.append(contentsOf: deck.cards)
            }
            let group = GroupOfDecks(name: groupDict.key, decks: decksInGroup)
            arrayOfGroups.append(group)
        }
        let allCardsDeck = Deck(name: "All", cards: allCards)
        let allCardsGroup = GroupOfDecks(name: "All", decks: [allCardsDeck])
        arrayOfGroups.append(allCardsGroup)
        return arrayOfGroups
    }
}
