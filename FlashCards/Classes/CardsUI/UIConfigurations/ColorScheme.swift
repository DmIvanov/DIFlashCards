//
//  ColorScheme.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 23/09/2019.
//

import UIKit


struct ColorScheme {
    
    enum Name: String, CaseIterable {
        case solarized
        case vanGog
        case grayTones
        case tangerineTeal
        case contrastRedAndBlue
        case rustyGun
    }
    
    static func scheme(name: ColorScheme.Name) -> ColorScheme {
        switch name {
        case .solarized: return solarized
        case .vanGog: return vanGog
        case .grayTones: return grayTones
        case .tangerineTeal: return tangerineTeal
        case .contrastRedAndBlue: return contrastRedAndBlue
        case .rustyGun: return rustyGun
        }
    }
    
    let navBarBackgroundColor: UIColor
    let navBarTextColor: UIColor
    
    let collectionBackground: UIColor
    
    let cardFrontBackgroundColor: UIColor
    let cardBackBackgroundColor: UIColor
    let cardFrontTextColor: UIColor
    let cardBackTextColor: UIColor
    
    let name: ColorScheme.Name
    
    static var defaultScheme = ColorScheme.rustyGun
    
    static let solarized = ColorScheme(
        navBarBackgroundColor: UIColor(rgb: 0x002b36),
        navBarTextColor: UIColor(rgb: 0xb58900),
        collectionBackground: UIColor(rgb: 0x586e75),
        cardFrontBackgroundColor: UIColor(rgb: 0x073642),
        cardBackBackgroundColor: UIColor(rgb: 0xeee8d5),
        cardFrontTextColor: UIColor(rgb: 0x268bd2),
        cardBackTextColor: UIColor(rgb: 0x268bd2),
        
        name: .solarized
    )
    
    static let vanGog = ColorScheme(
        navBarBackgroundColor: UIColor(rgb: 0x262228),
        navBarTextColor: UIColor.white,
        collectionBackground: UIColor(rgb: 0x007849),
        cardFrontBackgroundColor: UIColor(rgb: 0xffce00),
        cardBackBackgroundColor: UIColor(rgb: 0x0375b4),
        cardFrontTextColor: UIColor(rgb: 0x0375b4),
        cardBackTextColor: UIColor(rgb: 0xffce00),
        
        name: .vanGog
    )
    
    static let grayTones = ColorScheme(
        navBarBackgroundColor: UIColor(rgb: 0xf4f4f4),
        navBarTextColor: UIColor(rgb: 0x373737),
        collectionBackground: UIColor.gray,
        cardFrontBackgroundColor: UIColor(rgb: 0xf4f4f4),
        cardBackBackgroundColor: UIColor(rgb: 0x373737),
        cardFrontTextColor: UIColor(rgb: 0x373737),
        cardBackTextColor: UIColor(rgb: 0xf4f4f4),
        
        name: .grayTones
    )
    
    static let tangerineTeal = ColorScheme(
        navBarBackgroundColor: UIColor(rgb: 0xe37222),
        navBarTextColor: UIColor(rgb: 0xebe6e6),
        collectionBackground: UIColor(rgb: 0xeeaa7b),
        cardFrontBackgroundColor: UIColor(rgb: 0x66b9bf),
        cardBackBackgroundColor: UIColor(rgb: 0x07889b),
        cardFrontTextColor: UIColor(rgb: 0xebe6e6),
        cardBackTextColor: UIColor(rgb: 0xebe6e6),
        
        name: .tangerineTeal
    )
    
    static let contrastRedAndBlue = ColorScheme(
        navBarBackgroundColor: UIColor.black,
        navBarTextColor: UIColor.white,
        collectionBackground: UIColor(rgb: 0x813782),
        cardFrontBackgroundColor: UIColor(rgb: 0xb82601),
        cardBackBackgroundColor: UIColor(rgb: 0x062f4f),
        cardFrontTextColor: UIColor.white,
        cardBackTextColor: UIColor.white,
        
        name: .contrastRedAndBlue
    )
    
    static let rustyGun = ColorScheme(
        navBarBackgroundColor: UIColor(rgb: 0x18121e),
        navBarTextColor: UIColor(rgb: 0xebe6e6),
        collectionBackground: UIColor(rgb: 0xeac67a),
        cardFrontBackgroundColor: UIColor(rgb: 0x984b43),
        cardBackBackgroundColor: UIColor(rgb: 0x233237),
        cardFrontTextColor: UIColor(rgb: 0xebe6e6),
        cardBackTextColor: UIColor(rgb: 0xebe6e6),
        
        name: .rustyGun
    )
    /*
     static let  = ColorScheme(
     navBarBackgroundColor: UIColor(rgb: 0x),
     navBarTextColor: UIColor(rgb: 0x),
     collectionBackground: UIColor(rgb: 0x),
     cardFrontBackgroundColor: UIColor(rgb: 0x),
     cardBackBackgroundColor: UIColor(rgb: 0x),
     cardFrontTextColor: UIColor(rgb: 0x),
     cardBackTextColor: UIColor(rgb: 0x)
     )
     */
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
