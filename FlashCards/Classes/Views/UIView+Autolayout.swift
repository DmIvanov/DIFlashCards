//
//  UIView+Autolayout.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 24/08/2019.
//

import UIKit

extension UIView {
    
    static func autolayoutView() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func pinSubviewToEdges(subview: UIView, position: Int = 0, inset: CGFloat = 0.0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(subview, at: position)
        topAnchor.constraint(equalTo: subview.topAnchor, constant: -inset).isActive = true
        bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: inset).isActive = true
        leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: -inset).isActive = true
        trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: inset).isActive = true
    }
}
