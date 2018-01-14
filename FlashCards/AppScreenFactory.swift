//
//  AppScreenFactory.swift
//  FlashCards
//
//  Created by Dmitrii on 13/01/2018.
//

import UIKit

class AppScreenFactory {

    func cardVC() -> CardsTV {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsTV") as! CardsTV
    }

    func listVC() -> ListTV {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListTV") as! ListTV
    }
}
