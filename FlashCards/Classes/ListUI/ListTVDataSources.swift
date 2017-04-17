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
    func vcForSelectedItem(indexPath: IndexPath) -> UIViewController?
    func title() -> String
}


class GroupsDataSource: ListTVDataSource {
    
    let storage = GroupsStorage()
    
    
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
    
    func vcForSelectedItem(indexPath: IndexPath) -> UIViewController? {
        let idx = indexPath.row
        guard UInt(idx) < storage.groupsAmount() else {return nil}
        guard let group = storage.groupForIdx(idx: UInt(idx)) else {return nil}
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListTV") as? ListTV else {return nil}
        vc.dataSource = DecksDataSource(group: group)
        return vc
    }
    
    func title() -> String {
        return "Groups"
    }
}


class DecksDataSource: ListTVDataSource {
    
    let group: GroupOfDecks
    
    // MARK: Lifecycle
    init(group: GroupOfDecks) {
        self.group = group
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
    
    func vcForSelectedItem(indexPath: IndexPath) -> UIViewController? {
        let idx = indexPath.row
        guard idx < group.decks.count else {return nil}
        let deck = group.decks[idx]
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsTV") as? CardsTV else {return nil}
        vc.deck = deck
        return vc
    }
    
    func title() -> String {
        return group.name
    }
}
