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
    var dataSource: ListTVDataSource?
    @IBOutlet fileprivate var tableView: UITableView!
    
    
    //MARK: Lyfeccyle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = GroupsDataSource() //dataSource by default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navibarHeigh = navigationController?.navigationBar.frame.size.height {
            let statusbarHeigh: CGFloat = 20.0
            tableView.contentInset = UIEdgeInsetsMake(navibarHeigh + statusbarHeigh, 0, 0, 0)
        }
        title = dataSource?.title()
    }

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let source = dataSource else {return 0}
        return Int(source.numberOfSections())
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let source = dataSource else {return 0}
        return Int(source.numberOfItems(section: section))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath)
        if let item = dataSource?.item(indexPath: indexPath) {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = dataSource?.vcForSelectedItem(indexPath: indexPath) else {return}
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
