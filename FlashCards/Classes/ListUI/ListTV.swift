//
//  HeadingTV.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 24.01.16.
//
//

import UIKit

class ListTV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    var dataSource: ListTVDataSource!
    
    private let styleManager: StyleManager

    private let tableView = UITableView(frame: .zero)
    private let cellId = "ListTVCell"
    
    //MARK: Lyfecyle
    init(styleManager: StyleManager) {
        self.styleManager = styleManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scheme = styleManager.currentColorScheme
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListVCCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = scheme.cardFrontBackgroundColor
        view.pinSubviewToEdges(subview: tableView)
        title = dataSource.title()
    }

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(dataSource.numberOfSections())
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataSource.numberOfItems(section: section))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let item = dataSource.item(indexPath: indexPath) {
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = styleManager.currentColorScheme.cardFrontTextColor
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.itemSelected(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
