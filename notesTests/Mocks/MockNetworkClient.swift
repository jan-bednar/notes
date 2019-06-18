//
//  MockNetworkClient.swift
//  notesTests
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
@testable import notes

class MockNetworkClient: NetworkClient {
    
    var shouldFail = false
    
    func make<T>(dataRequest: T) -> Promise<T.Response> where T : NetworkRequest {
        guard !shouldFail else {
            return Promise(error: AFError.responseValidationFailed(reason: .dataFileNil))
        }
        
        if let request = dataRequest as? CreateNoteRequest {
            return Promise<Note>.value(Note(id: 1, title: request.newNote.title)) as! Promise<T.Response>
        }
        if let request = dataRequest as? UpdateNoteRequest {
            return Promise<Note>.value(Note(id: request.noteId, title: request.newNote.title)) as! Promise<T.Response>
        }
        if T.self is ListNotesRequest.Type {
            return Promise<[Note]>.value([Note(id: 1, title: "old note"), Note(id: 2, title: "new note")]) as! Promise<T.Response>
        }
        fatalError()
    }
    
    func make<T>(request: T) -> Promise<Void> where T : NetworkRequest {
        guard !shouldFail else {
            return Promise(error: AFError.responseValidationFailed(reason: .dataFileNil))
        }
        let removeNoteRequest = request as! RemoveNoteRequest
        
        if removeNoteRequest.noteId < 3 {
            return Promise<Void>.value(())
        } else {
            return Promise(error: AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 400)))
        }
    }
}
