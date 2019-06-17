//
//  GetNoteRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Alamofire

struct GetNoteRequest: NoteRequest {
    typealias Response = Note
    
    let noteId: Int
    let method: HTTPMethod = .get
    let body: Data? = nil
}
