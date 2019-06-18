//
//  ListNotesRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Alamofire

struct ListNotesRequest: NotesRequest {
    typealias Response = [Note]
    
    let method: HTTPMethod = .get
    let body: Data? = nil
}
