//
//  AppCoordinator.swift
//  notes
//
//  Created by Jan Bednar on 14/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start(animated: Bool)
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
    
    func start(animated: Bool) {
        let listCoordinator = ListCoordinator(navigationController: navigationController, networkClient: dependencies.networkClient)
        listCoordinator.delegate = self
        listCoordinator.start(animated: animated)
        childCoordinators.append(listCoordinator)
    }
    
    private func startDetailCoordinator(note: Note?) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, networkClient: dependencies.networkClient, note: note)
        detailCoordinator.start(animated: true)
        detailCoordinator.delegate = self
        childCoordinators.append(detailCoordinator)
    }
    
    func getChildCoordinator<T: Coordinator>(type: T.Type) -> T? {
        return childCoordinators.first(where: { $0.self is T }) as? T
    }
}

extension AppCoordinator: ListCoordinatorDelegate {
    func listCoordinatorSelect(note: Note) {
        startDetailCoordinator(note: note)
    }
    
    func listCoordinatorCreateNewNote() {
        startDetailCoordinator(note: nil)
    }
}

extension AppCoordinator: DetailCoordinatorDelegate {
    func detailCoordinatorFinished(note: Note?) {
        childCoordinators.removeAll(where: { $0.self is DetailCoordinator })
        guard let note = note else {
            return
        }
        getChildCoordinator(type: ListCoordinator.self)?.updateOrAdd(note: note)
    }
    
    func detailCoordinatorDeleted(note: Note) {
        childCoordinators.removeAll(where: { $0.self is DetailCoordinator })
        getChildCoordinator(type: ListCoordinator.self)?.remove(note: note)
    }
}
