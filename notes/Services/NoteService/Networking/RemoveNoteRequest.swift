//
//  RemoveNoteRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Alamofire

struct RemoveNoteRequest: NoteRequest {
    typealias Response = EmptyResponse
    
    let method: HTTPMethod = .delete
    let noteId: Int
    let body: Data? = nil
}
