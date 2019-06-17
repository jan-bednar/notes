//
//  UpdateNote.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Alamofire

struct UpdateNoteRequest: NoteRequest {
    typealias Response = Note
    
    let noteId: Int
    let newNote: NewNote
    let method: HTTPMethod = .put
    var body: Data? {
        return try? JSONEncoder().encode(newNote)
    }
}
