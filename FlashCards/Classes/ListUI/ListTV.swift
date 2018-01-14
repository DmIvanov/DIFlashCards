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
    @IBOutlet var tableView: UITableView!
    
    
    //MARK: Lyfecyle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath)
        if let item = dataSource.item(indexPath: indexPath) {
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
