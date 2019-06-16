//
//  APITests.swift
//  notesTests
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import XCTest
import PromiseKit
@testable import notes

class MockAPITests: XCTestCase {
    
    private var networkingClient: NetworkingClient!

    override func setUp() {
        server = .mock
        networkingClient = NetworkingClientImpl()
    }

    func test_listNotes_succeeds() {
        let request = ListNotesRequest()
        make(request: request) { notes in
            XCTAssertFalse(notes.isEmpty)
        }
    }
    
    func test_createNote_succeeds() {
        let newNote = NewNote(title: "Test note")
        let request = CreateNoteRequest(newNote: newNote)
        make(request: request) { note in
            XCTAssertEqual(note.id, 3)
            XCTAssertEqual(note.title, "Buy cheese and bread for breakfast.")
        }
    }
    
    func test_retrieveNote_succeeds() {
        let request = GetNoteRequest(noteId: 3)
        make(request: request) { note in
            XCTAssertEqual(note.id, 2)
            XCTAssertFalse(note.title.isEmpty)
        }
    }
    
    func test_updateNote_succeeds() {
        let request = UpdateNoteRequest(noteId: 1, newNote: NewNote(title: "Test note"))
        make(request: request) { note in
            XCTAssertEqual(note.id, 2)
            XCTAssertEqual(note.title, "Pick-up posters from post-office")
        }
    }
    
    private func make<T: NetworkRequest>(request: T, handler: @escaping (T.Response) -> Void) {
        let expectaion = expectation(description: "network call succeeds")
        
        networkingClient.make(request: request)
            .ensure {
                expectaion.fulfill()
            }.done { value in
                handler(value)
            }.catch { error in
                XCTFail()
        }
        wait(for: [expectaion], timeout: 2)
    }

}
