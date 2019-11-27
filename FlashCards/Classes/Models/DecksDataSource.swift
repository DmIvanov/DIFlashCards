//
//  DecksDataSources.swift
//  FlashCards
//
//  Created by Dmitrii on 16/04/2017.
//
//

import UIKit


protocol DecksDataSource {
    func numberOfSections() -> Int
    func numberOfItems(section: Int) -> Int
    func item(indexPath: IndexPath) -> ListTVItem?
    func itemSelected(indexPath: IndexPath)
    func title() -> String
    func initialDeck() -> Deck?
}


struct GroupOfDecks {
    let name: String
    let decks: [Deck]
}


class GroupDecksDataSource: DecksDataSource {
    
    weak var delegate: GroupDecksDataSourceDelegate?

    private let groupsOfDecks: [GroupOfDecks]

    // MARK: Lifecycle
    
    init(groups: [GroupOfDecks]) {
        self.groupsOfDecks = groups
    }
    
    func initialDeck() -> Deck? {
        let group = groupsOfDecks[groupsOfDecks.count - 1]
        return group.decks.first
    }
    
    // MARK: DecksDataSource methods
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(section: Int) -> Int {
        return groupsOfDecks.count
    }
    
    func item(indexPath: IndexPath) -> ListTVItem? {
        let idx = indexPath.row
        guard idx < groupsOfDecks.count else { return nil }
        guard let group = groupForIdx(idx: idx) else { return nil }
        return ListTVItem(
            title: group.name,
            subtitle: "\(group.decks.count) decks"
        )
    }

    func itemSelected(indexPath: IndexPath) {
        let idx = indexPath.row
        guard idx < groupsOfDecks.count else { return }
        guard let group = groupForIdx(idx: idx) else { return }
        delegate?.groupWasSelected(group: group)
    }
    
    func title() -> String {
        return "Groups"
    }
    
    // MARK: - Private
    
    private func decksAmountInGroup(groupIdx: Int) -> Int {
        guard groupIdx < groupsOfDecks.count else {return 0}
        let decsInGroup = groupsOfDecks[Int(groupIdx)].decks
        return decsInGroup.count
    }
    
    private func groupForIdx(idx: Int) -> GroupOfDecks? {
        guard idx < groupsOfDecks.count else { return nil }
        return groupsOfDecks[Int(idx)]
    }
}


protocol GroupDecksDataSourceDelegate: AnyObject {
    func groupWasSelected(group: GroupOfDecks)
}


class PlainDecksDataSource: DecksDataSource {
    
    private let name: String
    private let decks: [Deck]
    
    weak var delegate: PlainDecksDataSourceDelegate?
    
    // MARK: Lifecycle
    init(name: String, decks: [Deck]) {
        self.name = name
        self.decks = decks
    }
    
    // MARK: DecksDataSource methods
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(section: Int) -> Int {
        return decks.count
    }
    
    func item(indexPath: IndexPath) -> ListTVItem? {
        let idx = indexPath.row
        guard idx < decks.count else {return nil}
        let deck = decks[idx]
        return ListTVItem(
            title: deck.name,
            subtitle: "\(deck.cardsAmount()) cards"
        )
    }

    func itemSelected(indexPath: IndexPath) {
        let idx = indexPath.row
        guard idx < decks.count else {return}
        let deck = decks[idx]
        delegate?.deckWasSelected(deck: deck)
    }
    
    func title() -> String {
        return name
    }
    
    func initialDeck() -> Deck? {
        return decks.first
    }
}


protocol PlainDecksDataSourceDelegate: AnyObject {
    func deckWasSelected(deck: Deck)
}
