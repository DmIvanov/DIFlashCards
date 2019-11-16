//
//  CardsVC.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 26/09/2019.
//

import UIKit

class CardsVC: UIViewController {

    // MARK: - Public properties
    
    var dataSource: CardCollectionDataSource? {
        didSet {
            collectionViewController.dataSource = dataSource
        }
    }
    
    // MARK: - Private properties
    
    private let styleManager: StyleManager

    private let buttonsView: CardCollectionButtonPanel
    private let collectionViewController: CardCollectionViewController
    private let searchController = UISearchController(searchResultsController: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return collectionViewController.preferredStatusBarStyle
    }
    
    // MARK: - Lifecycle
    
    init(styleManager: StyleManager) {
        self.collectionViewController = CardCollectionViewController(styleManager: styleManager)
        self.buttonsView = CardCollectionButtonPanel.autolayoutView()
        self.styleManager = styleManager
        self.buttonsView.styleManager = styleManager
        
        super.init(nibName: nil, bundle: nil)
        
        adjustSearchController()

        addChild(collectionViewController)
        buttonsView.nextPressedCallback = nextButtonPressed
        buttonsView.previousPressedCallback = previousButtonPressed

        // until prev/next switch works properly
        buttonsView.isHidden = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = dataSource?.deckName()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Shuffle",
            style: .plain,
            target: self,
            action: #selector(shufflePressed)
        )
        view.addSubview(collectionViewController.view)
        view.addSubview(buttonsView)

        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // for some reason UISearchBar color customisation doesn't work from `viewDidLoad()`
        applyColorScheme()
    }
    
    //MARK: - Actions
    
    @IBAction fileprivate func shufflePressed() {
        guard let dataSource = dataSource else { return }
        dataSource.shuffleDeck()
        collectionViewController.reloadData()
    }
    
    // MARK: - Private functions
    
    @objc private func applyColorScheme() {
        searchController.searchBar.tintColor = styleManager.currentColorScheme.navBarTextColor
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = styleManager.currentColorScheme.navBarTextColor
    }
    
    private func setUpLayout() {
        let collectionView = collectionViewController.view!
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buttonsView.heightAnchor.constraint(equalToConstant: 100)
            ])
    }
    
    private func adjustSearchController() {
        guard #available(iOS 11.0, *) else { return }

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func filterContentForSearchText(searchText: String) {
        guard let dataSource = dataSource else { return }
        dataSource.filterContentForSearchText(searchText: searchText)
        collectionViewController.reloadData()
    }
    
    private func nextButtonPressed() {
        collectionViewController.showNextCard()
    }
    
    private func previousButtonPressed() {
        collectionViewController.showPreviousCard()
    }
}

// ----------------------------------------------------------------------------
// MARK: - UISearchResultsUpdating methods
// ----------------------------------------------------------------------------
extension CardsVC: UISearchResultsUpdating, UISearchControllerDelegate {

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
}
