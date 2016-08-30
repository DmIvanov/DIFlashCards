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
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var buttonSideUp: UIBarButtonItem!
    
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heading.cardsNumber()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.card = heading.cardForIdx((indexPath as NSIndexPath).row)
        cell.frontSide = !englishSideUp
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CardCell {
            cell.tapped()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Actions
    @IBAction fileprivate func shufflePressed() {
        heading.shuffle()
        tableView.reloadData()
    }
    
    @IBAction fileprivate func turnCards() {
        englishSideUp = !englishSideUp
    }
}
