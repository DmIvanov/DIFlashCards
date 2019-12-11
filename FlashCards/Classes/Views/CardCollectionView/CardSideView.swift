//
//  CardSideView.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 29/09/2019.
//

import UIKit

final class CardSideView: UIView {
    
    private let label = UILabel()
    private var separator = UIView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pinSubviewToEdges(subview: label, inset: 10)
        addSubview(separator)
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        label.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(title: String, subtitle: String?, colorScheme: ColorScheme, front: Bool, separateView: Bool) {
        backgroundColor = front ? colorScheme.cardFrontBackgroundColor : colorScheme.cardBackBackgroundColor
        setUpContent(titleString: title, subtitleString: subtitle, colorScheme: colorScheme, front: front)
        
        if separateView {
            separator.isHidden = true
        } else {
            separator.isHidden = false
            separator.backgroundColor = front ? colorScheme.cardBackBackgroundColor : colorScheme.cardFrontBackgroundColor
        }
    }
    
    private func setUpContent(titleString: String, subtitleString: String?, colorScheme: ColorScheme, front: Bool) {
        let titleColor = front ? colorScheme.cardFrontTextColor : colorScheme.cardBackTextColor
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 26.0)!,
            NSAttributedString.Key.foregroundColor: titleColor
        ]
        let title = NSMutableAttributedString(string: titleString, attributes: titleAttributes)
        let subtitleColor = front ? colorScheme.cardFrontTextColor2 : colorScheme.cardBackTextColor2
        if let sub = subtitleString {
            let subtitleAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 12.0)!,
                NSAttributedString.Key.foregroundColor: subtitleColor
            ]
            let gap = NSAttributedString(string: "\n\n")
            let subtitle = NSAttributedString(string: sub, attributes: subtitleAttributes)
            title.append(gap)
            title.append(subtitle)
        }
        label.attributedText = title
    }
}
