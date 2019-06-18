//
//  CoordinatorTest.swift
//  notesTests
//
//  Created by Jan Bednar on 18/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import XCTest

protocol CoordinatorTests {
    var navigationController: UINavigationController { get }
    func waitAfterStart(assertHandler: @escaping () -> Void)
    func assertVisibleViewControllerIsAlert()
}

extension CoordinatorTests where Self: XCTestCase {
    func waitAfterStart(assertHandler: @escaping () -> Void) {
        let exp = expectation(description: "waitAfterStart")
        
        DispatchQueue.init(label: "test").asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
            assertHandler()
        }
        wait(for: [exp], timeout: 0.6)
    }
    
    func assertVisibleViewControllerIsAlert() {
        let visibleViewController = self.navigationController.visibleViewController as? UIAlertController
        XCTAssertTrue(visibleViewController != nil)
    }
}
