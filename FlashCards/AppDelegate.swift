//
//  AppDelegate.swift
//  FlashCards
//
//  Created by Dmitry Ivanov on 23.01.16.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let interactor = AppInteractor()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        interactor.appDidLaunch(
            options:launchOptions,
            rootVC: window?.rootViewController
        )
        return true
    }
}

