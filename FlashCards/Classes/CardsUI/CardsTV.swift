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
    fileprivate var dataSource: CardCollectionDataSource?
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var buttonSideUp: UIBarButtonItem!
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = dataSource?.deckName()
        adjustSearchcontroller()
        hideSearchBar(animated: false)
    }

    // MARK: Public
    func setDataSource(_ dataSource: CardCollectionDataSource) {
        self.dataSource = dataSource
        if isViewLoaded {
            tableView.reloadData()
        }
    }

    
    //MARK: Actions
    @IBAction fileprivate func shufflePressed() {
        guard let dataSource = dataSource else { return }
        dataSource.shuffleDeck()
        tableView.reloadData()
    }
    
    @IBAction fileprivate func turnCards() {
        guard let dataSource = dataSource else { return }
        dataSource.changeCardsSide()
        if dataSource.frontSide {
            buttonSideUp.title = "eng"
        } else {
            buttonSideUp.title = "rus"
        }
        tableView.reloadData()
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
        guard let dataSource = dataSource else { return }
        dataSource.filterContentForSearchText(searchText: searchText)
        tableView.reloadData()
    }
    
    fileprivate func hideSearchBar(animated: Bool) {
        guard let dataSource = dataSource else { return }
        if (dataSource.deckSize() > 0) {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
        }
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
        guard let dataSource = dataSource else { return }
        dataSource.enableFiltering(true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        guard let dataSource = dataSource else { return }
        dataSource.enableFiltering(false)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        hideSearchBar(animated: true)
    }
}
