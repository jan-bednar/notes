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

struct Dependencies {
    let networkClient: NetworkClient = NetworkClientImpl()
}

class AppCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let dependencies = Dependencies()
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listCoordinator = ListCoordinator(navigationController: navigationController, networkClient: dependencies.networkClient)
        listCoordinator.delegate = self
        listCoordinator.start()
        childCoordinators.append(listCoordinator)
    }
}

extension AppCoordinator: ListCoordinatorDelegate {
    func listCoordinatorSelect(note: Note) {
        //
    }
    
    func listCoordinatorCreateNewNote() {
        //
    }
}


