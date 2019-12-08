//
//  SettingsListDataSource.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 27/11/2019.
//

import Foundation

enum SettingsItem: String, CaseIterable {
    case general = "General settings"
    case layout = "Layout settings"
}

class SettingsListDataSource: ListDataSource {

    weak var delegate: SettingsListDataSourceDelegate?
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfItems(section: Int) -> Int {
        SettingsItem.allCases.count
    }
    
    func item(indexPath: IndexPath) -> ListItem? {
        ListItem(title: SettingsItem.allCases[indexPath.row].rawValue, subtitle: "")
    }
    
    func itemSelected(indexPath: IndexPath) {
        let selectedItem = SettingsItem.allCases[indexPath.row]
        delegate?.itemSelected(item: selectedItem)
    }
    
    func title() -> String {
        "Settings"
    }
}

protocol SettingsListDataSourceDelegate: AnyObject {
    func itemSelected(item: SettingsItem)
}
