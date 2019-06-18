//
//  ListCoordinatorTests.swift
//  notesTests
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import XCTest
@testable import notes

class ListCoordinatorTests: XCTestCase, CoordinatorTests {

    let networkClient = MockNetworkClient()
    lazy var noteService: NoteService = NoteServiceImpl(networkClient: networkClient)
    var navigationController = UINavigationController()
    
    var coordinator: ListCoordinator!
    
    override func setUp() {
        super.setUp()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
    
    private func startCoordinator(shouldFail: Bool = false) {
        animationDuration = 0.0
        networkClient.shouldFail = shouldFail
        coordinator = ListCoordinator(navigationController: navigationController, noteService: noteService)
        coordinator.start(animated: false)
    }
    
    func test_afterStart_presentedViewControllerIsListControllerAndHasDelegate() {
        startCoordinator()
        
        let visibleController = navigationController.visibleViewController as? ListTableViewController
        
        XCTAssertTrue(visibleController != nil)
        XCTAssertTrue(visibleController?.delegate != nil)
    }
    
    func test_afterStartWithFailingNetwork_alertIsShown() {
        startCoordinator(shouldFail: true)
        
        waitAfterStart {
            let visibleController = self.navigationController.visibleViewController as? UIAlertController
            
            XCTAssertTrue(visibleController != nil)
        }
    }
    
    func test_refreshNotesWithFailingNetwork_alertIsShown() {
        startCoordinator()
        
        networkClient.shouldFail = true
        coordinator.listTableViewControllerRefresh()
        
        waitAfterStart {
            let visibleController = self.navigationController.visibleViewController as? UIAlertController
            
            XCTAssertTrue(visibleController != nil)
        }
    }
    
    func test_deleteNoteWithFailingNetwork_alertIsShown() {
        startCoordinator()
        
        networkClient.shouldFail = true
        coordinator.listTableViewControllerDelete(note: Note(id: 1, title: "text"))
        
        waitAfterStart {
            let visibleController = self.navigationController.visibleViewController as? UIAlertController
            
            XCTAssertTrue(visibleController != nil)
        }
    }
}
