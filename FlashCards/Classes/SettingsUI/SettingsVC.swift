//
//  SettingsVC.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 22/09/2019.
//

import UIKit

class SettingsVC: UIViewController {

    private let styleManager: StyleManager
    
    private var colorSchemePicker: UIPickerView!
    private var cardFront: UIView!
    private var cardBack: UIView!
    private var cardFrontLabel: UILabel!
    private var cardBackLabel: UILabel!
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        makeLayout()
        resetColorScheme()
        
        let currentSchemeIndex = Int(ColorScheme.Name.allCases.firstIndex(of: styleManager.currentColorScheme.name)!)
        colorSchemePicker.selectRow(currentSchemeIndex, inComponent: 0, animated: false)
    }
    
    private func makeLayout() {
        colorSchemePicker = UIPickerView.autolayoutView()
        colorSchemePicker.dataSource = self
        colorSchemePicker.delegate = self
        view.addSubview(colorSchemePicker)
        
        cardFront = UIView.autolayoutView()
        view.addSubview(cardFront)
        
        cardFrontLabel = UILabel.autolayoutView()
        cardFrontLabel.numberOfLines = 0
        cardFrontLabel.font = UIFont.systemFont(ofSize: 30)
        cardFrontLabel.textAlignment = .center
        cardFrontLabel.text = "That's how the FRONT side of the card will look like."
        cardFront.pinSubviewToEdges(subview: cardFrontLabel, position: 0, inset: 8)
        
        cardBack = UIView.autolayoutView()
        view.addSubview(cardBack)
        
        cardBackLabel = UILabel.autolayoutView()
        cardBackLabel.numberOfLines = 0
        cardBackLabel.font = UIFont.systemFont(ofSize: 30)
        cardBackLabel.textAlignment = .center
        cardBackLabel.text = "That's how the BACK side of the card will look like."
        cardBack.pinSubviewToEdges(subview: cardBackLabel, position: 0, inset: 8)
        
        
        NSLayoutConstraint.activate([
            colorSchemePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorSchemePicker.topAnchor.constraint(equalTo: view.topAnchor),
            colorSchemePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cardFront.topAnchor.constraint(equalTo: colorSchemePicker.bottomAnchor, constant: 20),
            
            cardFront.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            cardFront.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            cardBack.topAnchor.constraint(equalTo: cardFront.bottomAnchor, constant: -8),
            
            cardBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardBack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            ])
    }
    
    private func resetColorScheme() {
        let scheme = styleManager.currentColorScheme
        
        view.backgroundColor = scheme.collectionBackground
        cardFront.backgroundColor = scheme.cardFrontBackgroundColor
        cardFrontLabel.textColor = scheme.cardFrontTextColor
        cardBack.backgroundColor = scheme.cardBackBackgroundColor
        cardBackLabel.textColor = scheme.cardBackTextColor
        
        colorSchemePicker.backgroundColor = scheme.navBarBackgroundColor
        colorSchemePicker.reloadAllComponents()
    }
}


extension SettingsVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ColorScheme.Name.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = ColorScheme.Name.allCases[row]
        let scheme = styleManager.currentColorScheme
        let attributes = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor: scheme.navBarTextColor
        ]
        return NSAttributedString(string: title.rawValue, attributes: attributes)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let schemeName = ColorScheme.Name.allCases[row]
        let newScheme = ColorScheme.scheme(name: schemeName)
        styleManager.currentColorScheme = newScheme
        resetColorScheme()
    }
}
