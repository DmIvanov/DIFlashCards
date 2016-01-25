//
//  CardCell.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet private var label: UILabel!
    
    //let frontColor = UIColor(colorLiteralRed: 200.0/255.0, green: 172.0/255.0, blue: 1.0, alpha: 0.3)
    let frontColor = UIColor.clearColor()
    let backColor = UIColor(colorLiteralRed: 255.0/255.0, green: 250.0/255.0, blue: 172.0/255.0, alpha: 0.3)
    
    var card: Card? {
        didSet {
            frontSide = true
        }
    }
    var frontSide = true {
        didSet {
            guard let card = card else {return}
            if frontSide {
                label.text = card.rusString
                contentView.backgroundColor = frontColor
                
            } else {
                label.text = card.engString
                contentView.backgroundColor = backColor
            }
        }
    }
    
    func tapped() {
        frontSide = !frontSide
    }
}
