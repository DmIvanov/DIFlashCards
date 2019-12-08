//
//  ListCell.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 22/09/2019.
//

import UIKit

class ListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(item: ListItem, colorScheme: ColorScheme) {
        backgroundColor = UIColor.clear
        textLabel?.textColor = colorScheme.cardFrontTextColor
        textLabel?.text = item.title
        detailTextLabel?.textColor = colorScheme.cardFrontTextColor2
        detailTextLabel?.text = item.subtitle
    }
}

struct ListItem {
    let title: String
    let subtitle: String
}
