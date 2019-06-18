//
//  DetailCoordinatorTests.swift
//  notesTests
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import XCTest
@testable import notes

class DetailCoordinatorSpy: DetailCoordinatorDelegate {
    func detailCoordinatorFinished(note: Note?) {
        finishedNote = note
    }
    
    func detailCoordinatorDeleted(note: Note) {
        deletedNote = note
    }
    
    private(set) var finishedNote: Note?
    private(set) var deletedNote: Note?
}

class DetailCoordinatorTests: XCTestCase, CoordinatorTests {

    let networkClient = MockNetworkClient()
    lazy var noteService: NoteService = NoteServiceImpl(networkClient: networkClient)
    let navigationController = UINavigationController()
    let detailCoordinatorSpy = DetailCoordinatorSpy()
    
    var coordinator: DetailCoordinator!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
    
    func startCoordinator(shouldFail: Bool = false, note: Note? = nil) {
        animationDuration = 0.0
        networkClient.shouldFail = shouldFail
        coordinator = DetailCoordinator(navigationController: navigationController, noteService: noteService, note: note)
        coordinator.delegate = detailCoordinatorSpy
        coordinator.start(animated: false)
    }

    func test_afterStart_presentedViewControllerIsDetailControllerAndHasDelegate() {
        startCoordinator()
        
        let visibleController = navigationController.visibleViewController as? DetailViewController
        
        XCTAssertTrue(visibleController != nil)
        XCTAssertTrue(visibleController?.delegate != nil)
    }
    
    func test_afterDeletehWithFailingNetwork_alertIsShown() {
        startCoordinator(shouldFail: true, note: Note(id: 1, title: "test"))
        self.coordinator.detailViewControllerDidFinish(text: "")
        
        waitAfterStart {
            self.assertVisibleViewControllerIsAlert()
        }
    }
    
    func test_afterCreatingNewWithFailingNetwork_alertIsSHown() {
        startCoordinator(shouldFail: true)
        self.coordinator.detailViewControllerDidFinish(text: "New note")
        
        waitAfterStart {
            self.assertVisibleViewControllerIsAlert()
        }
    }
    
    func test_afterNotTypingAnythigInNewNote_detailFinishes() {
        startCoordinator(shouldFail: true)
        
        self.coordinator.detailViewControllerDidFinish(text: "")
        
        waitAfterStart {
            XCTAssertTrue(self.detailCoordinatorSpy.finishedNote == nil)
        }
    }
    
    func test_afterUpdateNote_detailFinishes() {
        startCoordinator(note: Note(id: 1, title: "test"))
        let updatedText = "test updated"
        self.coordinator.detailViewControllerDidFinish(text: updatedText)
        
        waitAfterStart {
            XCTAssertTrue(self.detailCoordinatorSpy.finishedNote != nil)
            XCTAssertEqual(self.detailCoordinatorSpy.finishedNote!.id, 1)
            XCTAssertEqual(self.detailCoordinatorSpy.finishedNote!.title, updatedText)
        }
    }
    
    func test_afterDeleteNote_detailFinishesWithDeletedNote() {
        startCoordinator(note: Note(id: 1, title: "test"))
        self.coordinator.detailViewControllerDidFinish(text: "")
        
        waitAfterStart {
            XCTAssertTrue(self.detailCoordinatorSpy.deletedNote != nil)
            XCTAssertEqual(self.detailCoordinatorSpy.deletedNote!.id, 1)
        }
    }

}
