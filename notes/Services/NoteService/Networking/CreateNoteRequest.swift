//
//  CreateNoteRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Alamofire

struct CreateNoteRequest: NotesRequest {
    typealias Response = Note
    
    let method: HTTPMethod = .post
    let newNote: NewNote
    
    var body: Data? {
        return try? JSONEncoder().encode(newNote)
    }
}
