//
//  NoteService.swift
//  notes
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import PromiseKit

protocol NoteService {
    func createNote(text: String) -> Promise<Note>
    func updateNote(text: String, id: Int)  -> Promise<Note>
    func remove(note: Note) -> Promise<Void>
    func getNotes() -> Promise<[Note]>
}

class NoteServiceImpl: NoteService {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func createNote(text: String) -> Promise<Note> {
        let newNote = NewNote(title: text)
        let request = CreateNoteRequest(newNote: newNote)
        return networkClient.make(dataRequest: request)
    }
    
    func updateNote(text: String, id: Int)  -> Promise<Note> {
        let newNote = NewNote(title: text)
        let request = UpdateNoteRequest(noteId: id, newNote: newNote)
        return networkClient.make(dataRequest: request)
    }
    
    func remove(note: Note) -> Promise<Void> {
        let request = RemoveNoteRequest(noteId: note.id)
        return networkClient.make(request: request)
    }
    
    func getNotes() -> Promise<[Note]> {
        let request = ListNotesRequest()
        return networkClient.make(dataRequest: request)
            .map { $0.sorted(by: { $0.id >= $1.id }) }
    }
}

