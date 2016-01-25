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
    private var tempHeading: Heading?
    @IBOutlet private var tableView: UITableView!
    
    
    //MARK: Lyfeccyle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navibarHeigh = navigationController?.navigationBar.frame.size.height {
            let statusbarHeigh: CGFloat = 20.0
            tableView.contentInset = UIEdgeInsetsMake(navibarHeigh + statusbarHeigh, 0, 0, 0)
        }
    }

    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.headingsNumber()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeadingCell", forIndexPath: indexPath)
        if let heading = storage.headingForIdx(indexPath.row) {
            cell.textLabel?.text = heading.name
            cell.detailTextLabel?.text = "\(heading.numberOfCards) cards"
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        tempHeading = storage.headingForIdx(indexPath.row)
        return indexPath
    }
    
    
    //MARK: 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCardsTV" {
            guard let cardsTV = segue.destinationViewController as? CardsTV else {return}
            guard let heading = tempHeading else {return}
            cardsTV.cardsStorage = heading.storage
        }
    }
}
