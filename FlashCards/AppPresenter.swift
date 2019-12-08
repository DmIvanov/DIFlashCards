//
//  AppPresenter.swift
//  FlashCards
//
//  Created by Dmitrii Ivanov on 14/11/2019.
//

import UIKit

class AppPresenter {

    private var splitVC: UISplitViewController?
    
    private var masterNC: UINavigationController!
    private var detailNC: UINavigationController!
    
    private var presentedVC: UIViewController?
    
    private let styleManager: StyleManager
    
    init(masterContentVC: UIViewController, detailContentVC: UIViewController, styleManager: StyleManager) {
        self.styleManager = styleManager
        self.masterNC = styleManager.currentColorScheme.customNavigationController(rootVC: masterContentVC)
        
        let isIPad = UIScreen.main.traitCollection.userInterfaceIdiom == .pad
        
        if isIPad {
            detailNC = styleManager.currentColorScheme.customNavigationController(rootVC: detailContentVC)
            splitVC = UISplitViewController(nibName: nil, bundle: nil)
            splitVC?.viewControllers = [masterNC, detailNC]
        } else {
            splitVC = nil
            detailNC = masterNC
            masterNC.pushViewController(detailContentVC, animated: false)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyColorScheme),
            name: StyleManager.kColorSchemeDidUpdateName,
            object: styleManager
        )
    }
    
    func rootVC() -> UIViewController {
        if let splitViewController = splitVC {
            return splitViewController
        } else {
            return masterNC
        }
    }
    
    func pushNewDetailVC(detailContentVC: UIViewController) {
        if let splitViewController = splitVC {
            let nc = styleManager.currentColorScheme.customNavigationController(rootVC: detailContentVC)
            splitViewController.showDetailViewController(nc, sender: nil)
        } else {
            masterNC.pushViewController(detailContentVC, animated: true)
        }
    }
    
    func pushNewMasterVC(masterContentVC: UIViewController) {
        masterNC.pushViewController(masterContentVC, animated: true)
    }
    
    func present(viewController: UIViewController, wrapToNavigation: Bool = true) {
        let vcToPresent = wrapToNavigation ? styleManager.currentColorScheme.customNavigationController(rootVC: viewController) : viewController
        let hostVC: UIViewController
        if let splitViewController = splitVC {
            hostVC = splitViewController
        } else {
            hostVC = masterNC
        }
        hostVC.present(vcToPresent, animated: true, completion: nil)
        presentedVC = vcToPresent
    }
    
    func dismissCurrentlyPresentingVC() {
        if let splitViewController = splitVC {
            splitViewController.dismiss(animated: true, completion: nil)
        } else {
            masterNC.dismiss(animated: true, completion: nil)
        }
        presentedVC = nil
    }
    
    @objc private func applyColorScheme() {
        let newScheme = styleManager.currentColorScheme
        newScheme.styleNavigationBar(navigationBar: masterNC.navigationBar)
        if let presentedNC = presentedVC as? UINavigationController {
            newScheme.styleNavigationBar(navigationBar: presentedNC.navigationBar)
        }
        if detailNC != masterNC {
            newScheme.styleNavigationBar(navigationBar: detailNC.navigationBar)
        }
    }
}
