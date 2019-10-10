//
//  StyleManager.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 24/09/2019.
//

import UIKit

class StyleManager {
    
    // MARK: - Public properties
    
    static let kColorSchemeDidUpdateName = NSNotification.Name("kColorSchemeDidUpdateKey")
    static let kCardsLayoutDidUpdateName = NSNotification.Name("kCardsLayoutDidUpdateName")

    var currentColorScheme: ColorScheme {
        didSet {
            persistentStorage.set(currentColorScheme.name.rawValue, forKey: colorSchemeKey)
            NotificationCenter.default.post(name: StyleManager.kColorSchemeDidUpdateName, object: self)
        }
    }
    var currentCardsLayout: FlowLayoutConfiguration {
        didSet {
            persistentStorage.set(currentCardsLayout.type.rawValue, forKey: cardsLayoutKey)
            NotificationCenter.default.post(name: StyleManager.kCardsLayoutDidUpdateName, object: self)
        }
    }
    
    // MARK: - Private properties
    
    private var currentFontName: String? = "Copperplate"
    
    private let colorSchemeKey = "styleManager.colorSchemeKey"
    private let cardsLayoutKey = "styleManager.cardsLayoutKey"

    private let persistentStorage: SettingsPersisting
    
    // MARK: - Lifecycle
    
    init(persistentStorage: SettingsPersisting = UserDefaults.standard) {
        self.persistentStorage = persistentStorage
        
        if let persistedColorSchemeName = persistentStorage.object(forKey: colorSchemeKey) as? String,
            let name = ColorScheme.Name(rawValue: persistedColorSchemeName) {
            currentColorScheme = ColorScheme.scheme(name: name)
        } else {
            currentColorScheme = ColorScheme.defaultScheme
        }
        
        if let persistentCardsLayoutName = persistentStorage.object(forKey: cardsLayoutKey) as? String,
            let configurationType = FlowLayoutConfiguration.FlowLayoutConfigurationType(rawValue: persistentCardsLayoutName) {
            currentCardsLayout = FlowLayoutConfiguration.configuration(type: configurationType)
        } else {
            currentCardsLayout = FlowLayoutConfiguration.defaultConfiguration
        }

    }
    
    // MARK: - Public functions
    
    func currentFont(size: CGFloat) -> UIFont? {
        if let name = currentFontName {
            return UIFont(name: name, size: size)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

protocol SettingsPersisting {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    
    func set(_ value: Int, forKey defaultName: String)
    func set(_ value: Double, forKey defaultName: String)
    func set(_ value: Bool, forKey defaultName: String)
    
    func integer(forKey defaultName: String) -> Int
    func double(forKey defaultName: String) -> Double
    func bool(forKey defaultName: String) -> Bool
}

extension UserDefaults: SettingsPersisting {}
