//
//  NoteRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Foundation

protocol NoteRequest: NetworkRequest {
    var noteId: Int { get }
}

extension NoteRequest {
    var path: String {
        return ["/notes", String(noteId)].joined(separator: "/")
    }
}
