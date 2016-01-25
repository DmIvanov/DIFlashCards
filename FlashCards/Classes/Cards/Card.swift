//
//  Card.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class Card: NSObject {
    
    //MARK: Properties
    let rusString: String
    let engString: String
    
    
    //MARK: Lyfecycle
    init(rus: String, eng: String) {
        self.rusString = rus
        self.engString = eng
    }
}
