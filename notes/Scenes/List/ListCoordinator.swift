//
//  ListCoordinator.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

protocol ListCoordinatorDelegate: AnyObject {
    func listCoordinatorSelect(note: Note)
    func listCoordinatorCreateNewNote()
}

class ListCoordinator: Coordinator {
    
    weak var delegate: ListCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let networkClient: NetworkClient
    
    private lazy var listViewController = ListTableViewController()
    
    init(navigationController: UINavigationController, networkClient: NetworkClient) {
        self.navigationController = navigationController
        self.networkClient = networkClient
    }
    
    func start() {
        listViewController.delegate = self
        navigationController.pushViewController(listViewController, animated: true)
        getNotes()
    }
    
    private func getNotes() {
        let request = ListNotesRequest()
        networkClient.make(dataRequest: request)
            .done { [weak self] notes in
                self?.listViewController.update(notes: notes)
            }.catch { [weak self] error in
                self?.listViewController.update(notes: [])
                self?.show(error: error, text: NSLocalizedString("list_get_notes_error", comment: "Could not download notes"))
            }
    }
    
    private func show(error: Error, text: String?) {
        let title = text ?? NSLocalizedString("general_alert_title", comment: "Oops, tha's not good!")
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("general_ok", comment: "OK"), style: .default, handler: { [weak self] _ in
            self?.navigationController.topViewController?.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        navigationController.topViewController?.present(alertController, animated: true)
    }
}

extension ListCoordinator: ListTableViewControllerDelegate {
    func listTableViewControllerDelete(note: Note) {
        let request = RemoveNoteRequest(noteId: note.id)
        networkClient.make(request: request)
            .catch { [weak self] error in
                self?.show(error: error, text: NSLocalizedString("list_delete_note_error", comment: "Deleting note has failed"))
            }
    }
    
    func listTableViewControllerSelect(note: Note) {
        delegate?.listCoordinatorSelect(note: note)
    }
    
    func listTableViewControllerRefresh() {
        getNotes()
    }
}
