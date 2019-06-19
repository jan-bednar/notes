//
//  DetailCoordinator.swift
//  notes
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit
import PromiseKit

protocol DetailCoordinatorDelegate: AnyObject {
    func detailCoordinatorFinished(note: Note?)
    func detailCoordinatorDeleted(note: Note)
}

class DetailCoordinator: Coordinator, ErrorPresentable, HasLoading {
    
    weak var delegate: DetailCoordinatorDelegate?
    
    private let navigationController: UINavigationController
    private let noteService: NoteService
    private let note: Note?
    private var loadingViewController: LoadingViewController?
    
    init(navigationController: UINavigationController, noteService: NoteService, note: Note?) {
        self.navigationController = navigationController
        self.noteService = noteService
        self.note = note
    }
    
    func start(animated: Bool) {
        let viewController = DetailViewController()
        viewController.delegate = self
        if let note = self.note {
            viewController.set(originalText: note.title)
        }
        let detailNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(detailNavigationController, animated: animated, completion: nil)
    }
    
    private func createNote(text: String) {
        handle(promise: noteService.createNote(text: text), errorMessage: L10n.detailCreateNoteError)
    }
    
    private func updateNote(text: String, id: Int) {
        handle(promise: noteService.updateNote(text: text, id: id), errorMessage: L10n.detailUpdateNoteError)
    }
    
    private func remove(note: Note) {
        guard let visibleViewController = navigationController.visibleViewController else {
            return
        }
        let (loadingPromise, loadingViewController) = showLoading(in: visibleViewController)
    
        when(fulfilled: loadingPromise, noteService.remove(note: note) )
            .ensureThen { [weak self] in
                self?.remove(loadingViewController: loadingViewController) ?? Guarantee()
            }.done { [weak self] _ in
                self?.navigationController.dismiss(animated: true, completion: nil)
                self?.delegate?.detailCoordinatorDeleted(note: note)
            }.catch { [weak self] error in
                let errorMessage = L10n.detailRemoveNoteError
                self?.show(error: error, text: errorMessage, on: self?.navigationController)
            }
    }
    
    private func handle(promise: Promise<Note>, errorMessage: String) {
        guard let visibleViewController = navigationController.visibleViewController else {
            return
        }
        
        let (loadingPromise, loadingViewController) = showLoading(in: visibleViewController)
        
        when(fulfilled: loadingPromise, promise)
            .ensureThen { [weak self] in
                self?.remove(loadingViewController: loadingViewController) ?? Guarantee()
            }.done { [weak self] (_, note) in
                self?.navigationController.dismiss(animated: true, completion: nil)
                self?.delegate?.detailCoordinatorFinished(note: note)
            }.catch { [weak self] error in
                self?.show(error: error, text: errorMessage, on: self?.navigationController)
            }
    }
}

extension DetailCoordinator: DetailViewControllerDelegate {
    func detailViewControllerDidFinish(text: String) {
        switch (text.isEmpty, self.note) {
        case (true, .some(let note)):
            remove(note: note)
        case (true, .none):
            delegate?.detailCoordinatorFinished(note: nil)
            navigationController.dismiss(animated: true, completion: nil)
        case (false, .some(let note)):
            updateNote(text: text, id: note.id)
        case (false, .none):
            createNote(text: text)
        }
    }
}
