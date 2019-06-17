//
//  ListCoordinator.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit
import PromiseKit

protocol ListCoordinatorDelegate: AnyObject {
    func listCoordinatorSelect(note: Note)
    func listCoordinatorCreateNewNote()
}

class ListCoordinator: Coordinator, ErrorPresentable, HasLoading {
    
    weak var delegate: ListCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let networkClient: NetworkClient
    
    private lazy var listViewController = ListTableViewController()
    
    private var notes: [Note] = []
    
    init(navigationController: UINavigationController, networkClient: NetworkClient) {
        self.navigationController = navigationController
        self.networkClient = networkClient
    }
    
    func start(animated: Bool) {
        navigationController.navigationBar.prefersLargeTitles = true
        listViewController.delegate = self
        navigationController.pushViewController(listViewController, animated: animated)
        let (loadingPromise, loadingViewController) = showLoading(in: listViewController, animated: false)

        when(fulfilled: loadingPromise, getNotes())
            .ensure { [weak self] in
                self?.remove(loadingViewController: loadingViewController)
            }
            .done { [weak self] _, notes in
                self?.notes = notes
                self?.listViewController.update(notes: notes)
            }.catch { [weak self] error in
                self?.listViewController.update(notes: self?.notes ?? [])
                self?.show(error: error, text: NSLocalizedString("list_get_notes_error", comment: "Could not download notes"), on: self?.navigationController)
        }
    }
    
    func remove(note: Note) {
        notes = notes.filter { $0 != note }
        listViewController.update(notes: notes)
    }
    
    func updateOrAdd(note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.insert(note, at: 0)
        }
        listViewController.update(notes: notes)
    }
    
    private func refreshNotes() {
        getNotes()
            .done { [weak self] notes in
                self?.notes = notes
                self?.listViewController.update(notes: notes)
            }.catch { [weak self] error in
                self?.listViewController.update(notes: self?.notes ?? [])
                self?.show(error: error, text: NSLocalizedString("list_get_notes_error", comment: "Could not download notes"), on: self?.navigationController)
            }
    }
    
    private func getNotes() -> Promise<[Note]> {
        let request = ListNotesRequest()
        return networkClient.make(dataRequest: request)
            .map { $0.sorted(by: { $0.id >= $1.id }) }
    }
}

extension ListCoordinator: ListTableViewControllerDelegate {
    func listTableViewControllerCreateNewNote() {
        delegate?.listCoordinatorCreateNewNote()
    }
    
    func listTableViewControllerSearch(text: String?) {
        if let text = text?.lowercased(), !text.isEmpty {
            let filteredNotes = notes.filter{ $0.title.lowercased().contains(text) }
            listViewController.update(notes: filteredNotes)
        } else {
            listViewController.update(notes: notes)
        }
    }
    
    func listTableViewControllerDelete(note: Note) {
        let request = RemoveNoteRequest(noteId: note.id)
        networkClient.make(request: request)
            .catch { [weak self] error in
                self?.show(error: error, text: NSLocalizedString("list_delete_note_error", comment: "Deleting note has failed"), on: self?.navigationController)
            }
    }
    
    func listTableViewControllerSelect(note: Note) {
        delegate?.listCoordinatorSelect(note: note)
    }
    
    func listTableViewControllerRefresh() {
        refreshNotes()
    }
}
