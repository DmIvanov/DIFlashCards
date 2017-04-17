//
//  CardsTV.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

class CardsTV: UIViewController {
    
    //MARK: Properties
    var deck = Deck(name: "")
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
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navibarHeigh = navigationController?.navigationBar.frame.size.height {
            let statusbarHeigh: CGFloat = 20.0
            tableView.contentInset = UIEdgeInsetsMake(navibarHeigh + statusbarHeigh, 0, 0, 0)
        }
        englishSideUp = false
        navigationItem.title = deck.name
        adjustSearchcontroller()
        hideSearchBar(animated: false)
    }

    
    //MARK: Actions
    @IBAction fileprivate func shufflePressed() {
        deck.shuffle()
        tableView.reloadData()
    }
    
    @IBAction fileprivate func turnCards() {
        englishSideUp = !englishSideUp
    }
    
    
    // MARK: Private
    fileprivate func adjustSearchcontroller() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.gray
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    fileprivate func filterContentForSearchText(searchText: String) {
        deck.filterCardsForSearchText(searchText: searchText)
        tableView.reloadData()
    }
    
    fileprivate func hideSearchBar(animated: Bool) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
}



// ----------------------------------------------------------------------------
// MARK: - UITableViewDelegate, UITableViewDataSource methods
// ----------------------------------------------------------------------------
extension CardsTV: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.cardsAmount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.card = deck.cardForIdx((indexPath as NSIndexPath).row)
        cell.frontSide = !englishSideUp
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CardCell {
            cell.tapped()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// ----------------------------------------------------------------------------
// MARK: - UISearchResultsUpdating methods
// ----------------------------------------------------------------------------
extension CardsTV: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        deck.filtering = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        deck.filtering = false
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(animated: true)
    }
}
