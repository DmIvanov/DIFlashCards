//
//  ListTVDataSources.swift
//  FlashCards
//
//  Created by Dmitrii on 16/04/2017.
//
//

import UIKit


struct ListTVItem {
    let title: String
    let subtitle: String
}


protocol ListTVDataSource {
    func numberOfSections() -> UInt
    func numberOfItems(section: Int) -> UInt
    func item(indexPath: IndexPath) -> ListTVItem?
    func itemSelected(indexPath: IndexPath)
    func title() -> String
}


class GroupsDataSource: ListTVDataSource {
    
    weak var delegate: GroupsDataSourceDelegate?

    private let storage = GroupsStorage()

    // MARK: Lifecycle
    
    func initialDeck() -> Deck? {
        return storage.defaultDeck()
    }
    
    // MARK: ListTVDataSource methods
    
    func numberOfSections() -> UInt {
        return 1
    }
    
    func numberOfItems(section: Int) -> UInt {
        return storage.groupsAmount()
    }
    
    func item(indexPath: IndexPath) -> ListTVItem? {
        let idx = indexPath.row
        guard UInt(idx) < storage.groupsAmount() else {return nil}
        guard let group = storage.groupForIdx(idx: UInt(idx)) else {return nil}
        return ListTVItem(
            title: group.name,
            subtitle: "\(group.decks.count) decks"
        )
    }

    func itemSelected(indexPath: IndexPath) {
        let idx = indexPath.row
        guard UInt(idx) < storage.groupsAmount() else {return}
        guard let group = storage.groupForIdx(idx: UInt(idx)) else {return}
        delegate?.groupWasSelected(group: group)
    }
    
    func title() -> String {
        return "Groups"
    }
}


protocol GroupsDataSourceDelegate: AnyObject {
    func groupWasSelected(group: GroupOfDecks)
}


class DecksDataSource: ListTVDataSource {
    
    private let group: GroupOfDecks
    private weak var delegate: DecksDataSourceDelegate?
    
    // MARK: Lifecycle
    init(group: GroupOfDecks, delegate: DecksDataSourceDelegate) {
        self.group = group
        self.delegate = delegate
    }
    
    // MARK: ListTVDataSource methods
    
    func numberOfSections() -> UInt {
        return 1
    }
    
    func numberOfItems(section: Int) -> UInt {
        return UInt(group.decks.count)
    }
    
    func item(indexPath: IndexPath) -> ListTVItem? {
        let idx = indexPath.row
        guard idx < group.decks.count else {return nil}
        let deck = group.decks[idx]
        return ListTVItem(
            title: deck.name,
            subtitle: "\(deck.cardsAmount()) cards"
        )
    }

    func itemSelected(indexPath: IndexPath) {
        let idx = indexPath.row
        guard idx < group.decks.count else {return}
        let deck = group.decks[idx]
        delegate?.deckWasSelected(deck: deck)
    }
    
    func title() -> String {
        return group.name
    }
}


protocol DecksDataSourceDelegate: AnyObject {
    func deckWasSelected(deck: Deck)
}
