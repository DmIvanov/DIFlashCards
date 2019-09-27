//
//  StatusbarManagingExtensions.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 27/09/2019.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}

extension UISplitViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewControllers.first?.preferredStatusBarStyle ?? .lightContent
    }
}
