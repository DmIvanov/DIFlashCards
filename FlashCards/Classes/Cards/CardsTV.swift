//
//  CardsTV.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class CardsTV: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var heading = Heading(name: "")
    var englishSideUp = false {
        didSet {
            if englishSideUp {
                buttonSideUp.title = "eng"
            } else {
                buttonSideUp.title = "rus"
            }
            tableView.reloadData()
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var buttonSideUp: UIBarButtonItem!
    
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navibarHeigh = navigationController?.navigationBar.frame.size.height {
            let statusbarHeigh: CGFloat = 20.0
            tableView.contentInset = UIEdgeInsetsMake(navibarHeigh + statusbarHeigh, 0, 0, 0)
        }
        englishSideUp = false
    }


    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heading.cardsNumber()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath) as! CardCell
        cell.card = heading.cardForIdx(indexPath.row)
        cell.frontSide = !englishSideUp
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? CardCell {
            cell.tapped()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: Actions
    @IBAction private func shufflePressed() {
        heading.shuffle()
        tableView.reloadData()
    }
    
    @IBAction private func turnCards() {
        englishSideUp = !englishSideUp
    }
}
