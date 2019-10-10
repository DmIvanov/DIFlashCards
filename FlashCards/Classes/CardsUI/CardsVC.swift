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
    
    private let buttonsView: CardCollectionButtonPanel
    private let collectionViewController: CardCollectionViewController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return collectionViewController.preferredStatusBarStyle
    }
    
    // MARK: - Lifecycle
    
    init(styleManager: StyleManager) {
        self.collectionViewController = CardCollectionViewController(styleManager: styleManager)
        self.buttonsView = CardCollectionButtonPanel.autolayoutView()
        self.buttonsView.styleManager = styleManager
        super.init(nibName: nil, bundle: nil)
        addChild(collectionViewController)
        view.backgroundColor = styleManager.currentColorScheme.collectionBackground
        buttonsView.nextPressedCallback = nextButtonPressed
        buttonsView.previousPressedCallback = previousButtonPressed
        
        // until prev/next switch doesn't properly work
        buttonsView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK: - Actions
    
    @IBAction fileprivate func shufflePressed() {
        guard let dataSource = dataSource else { return }
        dataSource.shuffleDeck()
        collectionViewController.collectionView.reloadData()
    }
    
    // MARK: - Private functions
    
    private func setUpLayout() {
        let collectionView = collectionViewController.view!
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buttonsView.heightAnchor.constraint(equalToConstant: 100)
            ])
    }
    
    private func nextButtonPressed() {
        collectionViewController.showNextCard()
    }
    
    private func previousButtonPressed() {
        collectionViewController.showPreviousCard()
    }
}
