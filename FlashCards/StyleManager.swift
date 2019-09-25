//
//  StyleManager.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 24/09/2019.
//

import Foundation

class StyleManager {
    
    var currentColorScheme: ColorScheme {
        didSet {
            persistentStorage.set(currentColorScheme.name.rawValue, forKey: colorSchemeKey)
        }
    }
    
    private let colorSchemeKey = "styleManager.colorSchemeKey"
    
    private let persistentStorage: SettingsPersisting
    
    init(persistentStorage: SettingsPersisting = UserDefaults.standard) {
        self.persistentStorage = persistentStorage
        if let persistedColorSchemeName = persistentStorage.object(forKey: colorSchemeKey) as? String,
            let name = ColorScheme.Name(rawValue: persistedColorSchemeName) {
            currentColorScheme = ColorScheme.scheme(name: name)
        } else {
            currentColorScheme = ColorScheme.defaultScheme
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
