//
//  ListTV.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 24.01.16.
//
//

import UIKit

class ListTV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    var dataSource: ListDataSource!
    
    private let styleManager: StyleManager

    private let tableView = UITableView(frame: .zero)
    private let cellId = "ListTVCell"
    
    //MARK: Lyfecyle
    
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return styleManager.currentColorScheme.statusBarStyle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListCell.self, forCellReuseIdentifier: cellId)
        view.pinSubviewToEdges(subview: tableView)
        title = dataSource.title()
        
        applyColorScheme()
    }

    // MARK: - Private
    
    @objc private func applyColorScheme() {
        let scheme = styleManager.currentColorScheme
        tableView.backgroundColor = scheme.cardFrontBackgroundColor
        tableView.reloadData()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(dataSource.numberOfSections())
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataSource.numberOfItems(section: section))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListCell
        if let item = dataSource.item(indexPath: indexPath) {
            cell.update(item: item, colorScheme: styleManager.currentColorScheme)
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.itemSelected(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

protocol ListDataSource {
    func numberOfSections() -> Int
    func numberOfItems(section: Int) -> Int
    func item(indexPath: IndexPath) -> ListItem?
    func itemSelected(indexPath: IndexPath)
    func title() -> String
}
