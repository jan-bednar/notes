//
//  AppCoordinator.swift
//  notes
//
//  Created by Jan Bednar on 14/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = UIViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
