//
//  HeadingTV.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 24.01.16.
//
//

import UIKit

class HeadingTV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    let storage = HeadingsStorage()
    fileprivate var tempHeading: Heading?
    @IBOutlet fileprivate var tableView: UITableView!
    
    
    //MARK: Lyfeccyle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navibarHeigh = navigationController?.navigationBar.frame.size.height {
            let statusbarHeigh: CGFloat = 20.0
            tableView.contentInset = UIEdgeInsetsMake(navibarHeigh + statusbarHeigh, 0, 0, 0)
        }
    }

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.headingsNumber()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingCell", for: indexPath)
        if let heading = storage.headingForIdx((indexPath as NSIndexPath).row) {
            cell.textLabel?.text = heading.name
            cell.detailTextLabel?.text = "\(heading.cardsNumber()) cards"
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tempHeading = storage.headingForIdx((indexPath as NSIndexPath).row)
        return indexPath
    }
    
    
    //MARK: 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCardsTV" {
            guard let cardsTV = segue.destination as? CardsTV else {return}
            guard let heading = tempHeading else {return}
            cardsTV.heading = heading
        }
    }
}
