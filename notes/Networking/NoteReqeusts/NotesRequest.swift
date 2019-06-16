//
//  NotesRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Foundation

protocol NotesRequest: NetworkRequest {}

extension NotesRequest {
    var path: String {
        return "/notes"
    }
}
