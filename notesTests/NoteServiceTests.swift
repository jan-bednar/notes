//
//  NoteServiceTests.swift
//  notesTests
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import XCTest
import PromiseKit
@testable import notes

class NoteServiceTests: XCTestCase {
    
    var sut: NoteService!
    
    override func setUp() {
        sut = NoteServiceImpl(networkClient: MockNetworkClient())
    }
    
    func test_createNote_succeeds() {
        let text = "New note"
        sut.createNote(text: text)
            .done { (note) in
                XCTAssertEqual(note.title, text)
                XCTAssertTrue(note.id >= 1)
            }.cauterize()
    }
    
    func test_updateNote_succeeds() {
        var originalNote: Note!
        sut.getNotes()
            .firstValue
            .then { note -> Promise<Note> in
                originalNote = note
                return self.sut.updateNote(text: note.title + "edited", id: note.id)
            }.done { (updatedNote) in
                XCTAssertEqual(updatedNote.title, originalNote.title + "edited")
                XCTAssertEqual(updatedNote.id, originalNote.id)
            }.cauterize()
    }
    
    func test_removeNoteWithValidId_succeeds() {
        let note = Note(id: 1, title: "")
        sut.remove(note: note)
            .catch { error in
                XCTFail(error.localizedDescription)
        }
    }
    
    func test_removeNoteWithInvalidId_fails() {
        let note = Note(id: 4, title: "")
        sut.remove(note: note)
            .done {
                XCTFail("Removing note ended with success, even though it should have failed!")
            }.cauterize()
    }
    
    func test_getNotes_returnsNotesSortedWithDescendingOrder() {
        sut.getNotes()
            .done { notes in
            XCTAssertTrue(notes.count >= 2)
            XCTAssertTrue(notes.first!.id > notes.last!.id)
            }.cauterize()
    }

}
