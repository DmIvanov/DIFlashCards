//
//  Card.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class Card: NSObject {
    
    let frontString: String
    let backString: String
    var path: String?
    
    init(frontString: String, backString: String) {
        self.frontString = frontString
        self.backString = backString
    }
}
