//
//  Server.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Foundation

struct Server {
    let stringUrl: String
    
    static let mock = Server(stringUrl: "https://private-anon-c4a2f395bc-note10.apiary-mock.com")
}

var server: Server = .mock
