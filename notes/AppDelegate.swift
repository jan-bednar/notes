//
//  AppDelegate.swift
//  notes
//
//  Created by Jan Bednar on 14/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start(animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}

