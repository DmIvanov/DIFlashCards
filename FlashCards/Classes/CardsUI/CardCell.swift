//
//  CardCell.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet fileprivate var label: UILabel!
    
    //let frontColor = UIColor(colorLiteralRed: 200.0/255.0, green: 172.0/255.0, blue: 1.0, alpha: 0.3)
    let frontColor = UIColor.clear
    let backColor = UIColor(colorLiteralRed: 255.0/255.0, green: 250.0/255.0, blue: 172.0/255.0, alpha: 0.3)
    
    var card: Card? {
        didSet {
            frontSide = true
        }
    }
    var frontSide = true {
        didSet {
            guard let card = card else {return}
            guard card.path != nil else {return}
            if frontSide {
                label.text = card.rusString
                contentView.backgroundColor = frontColor
            } else {
                label.attributedText = textForLabel(content: card.engString+"\n\n", path: "\(card.path!)")
                contentView.backgroundColor = backColor
            }
        }
    }
    
    func tapped() {
        frontSide = !frontSide
    }
    
    
    private func textForLabel(content: String, path: String) -> NSAttributedString {
        let contentAttr = [
            NSFontAttributeName: UIFont(name: "Copperplate", size: 26.0)!
        ]
        let contentPart = NSMutableAttributedString(string: content, attributes: contentAttr)
        let pathAttr = [
            NSFontAttributeName: UIFont.italicSystemFont(ofSize: 14.0),
            NSForegroundColorAttributeName: UIColor.gray
        ]
        let pathPart = NSAttributedString(string: path, attributes: pathAttr)
        contentPart.append(pathPart)
        return contentPart
    }
}
