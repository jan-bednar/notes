//
//  Note.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Foundation

struct Note: Codable {
    let id: Int
    let title: String
}

extension Note: Equatable {}
