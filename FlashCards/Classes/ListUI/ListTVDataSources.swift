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
    
    let interactor: ListInteractor

    // MARK: Lifecycle
    init(interactor: ListInteractor) {
        self.interactor = interactor
    }
    
    
    // MARK: ListTVDataSource methods
    
    func numberOfSections() -> UInt {
        return 1
    }
    
    func numberOfItems(section: Int) -> UInt {
        return interactor.storage.groupsAmount()
    }
    
    func item(indexPath: IndexPath) -> ListTVItem? {
        let idx = indexPath.row
        guard UInt(idx) < interactor.storage.groupsAmount() else {return nil}
        guard let group = interactor.storage.groupForIdx(idx: UInt(idx)) else {return nil}
        return ListTVItem(
            title: group.name,
            subtitle: "\(group.decks.count) decks"
        )
    }

    func itemSelected(indexPath: IndexPath) {
        let idx = indexPath.row
        guard UInt(idx) < interactor.storage.groupsAmount() else {return}
        guard let group = interactor.storage.groupForIdx(idx: UInt(idx)) else {return}
        interactor.pushNewGroup(group)
    }
    
    func title() -> String {
        return "Groups"
    }
}


class DecksDataSource: ListTVDataSource {
    
    let group: GroupOfDecks
    let interactor: ListInteractor
    
    // MARK: Lifecycle
    init(group: GroupOfDecks, interactor: ListInteractor) {
        self.group = group
        self.interactor = interactor
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
        interactor.deckWasChosen(deck)
    }
    
    func title() -> String {
        return group.name
    }
}
