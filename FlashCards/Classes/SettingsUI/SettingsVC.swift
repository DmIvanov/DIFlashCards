//
//  SettingsVC.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 22/09/2019.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - Properties
    
    private let styleManager: StyleManager
    
    private let mainStack = UIStackView.autolayoutView()
    private var colorSchemePicker: SingleSettingViewController!
    private var layoutPicker: SingleSettingViewController!
    private var cardsVC: CardCollectionViewController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return styleManager.currentColorScheme.statusBarStyle
    }
    
    // MARK: - Lifecycle
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStack.axis = .vertical
        mainStack.spacing = 4
        view.pinSubviewToEdges(subview: mainStack)
        
        let colorSchemes = ColorScheme.Name.allCases.map { (name) -> String in
            return name.rawValue
        }
        let currentSchemeIndex = Int(ColorScheme.Name.allCases.firstIndex(of: styleManager.currentColorScheme.name)!)
        colorSchemePicker = SingleSettingViewController(
            title: "Color Scheme",
            dataSourse: colorSchemes,
            delegate: self,
            styleManager: styleManager,
            selectedItem: currentSchemeIndex
        )
        colorSchemePicker.view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addContentController(colorSchemePicker)
        
        let configurations = FlowLayoutConfiguration.FlowLayoutConfigurationType.allCases.map { (type) -> String in
            return type.rawValue
        }
        let currentLayoutIndex = Int(FlowLayoutConfiguration.FlowLayoutConfigurationType.allCases.firstIndex(of: styleManager.currentCardsLayout.type)!)
        layoutPicker = SingleSettingViewController(
            title: "Cards layout",
            dataSourse: configurations,
            delegate: self,
            styleManager: styleManager,
            selectedItem: currentLayoutIndex
        )
        layoutPicker.view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addContentController(layoutPicker)
        
        let cards = [
            Card(frontString: "Here is how the card will look like", backString: "...and that's the back side of it"),
            Card(frontString: "Here is how the card will look like", backString: "...and that's the back side of it"),
            Card(frontString: "Here is how the card will look like", backString: "...and that's the back side of it"),
        ]
        let deck = Deck(name: "", path: nil, cards: cards)
        let dataSourse = CardCollectionDataSource(deck: deck)
        cardsVC = CardCollectionViewController(styleManager: styleManager)
        cardsVC.dataSource = dataSourse
        cardsVC.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        addContentController(cardsVC)
        
        makeLayout()
        resetColorScheme()
    }
    
    // MARK: - Private
    
    private func makeLayout() {
//        view.addSubview(colorSchemePicker.view)
//        view.addSubview(layoutPicker.view)
//        view.addSubview(cardsVC.view)
    }
    
    private func resetColorScheme() {
        let scheme = styleManager.currentColorScheme
        
        view.backgroundColor = scheme.collectionBackground
        colorSchemePicker.resetColorScheme()
        layoutPicker.resetColorScheme()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func addContentController(_ child: UIViewController) {
        addChild(child)
        mainStack.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
}

extension SettingsVC: SingleSettingViewControllerDelegate {
    func itemDidSelect(index: Int, sender: SingleSettingViewController) {
        if sender == colorSchemePicker {
            let schemeName = ColorScheme.Name.allCases[index]
            let newScheme = ColorScheme.scheme(name: schemeName)
            styleManager.currentColorScheme = newScheme
            resetColorScheme()
        } else if sender == layoutPicker {
            let configurationType = FlowLayoutConfiguration.FlowLayoutConfigurationType.allCases[index]
            let configuration = FlowLayoutConfiguration.configuration(type: configurationType)
            styleManager.currentCardsLayout = configuration
        }
    }
}
