//
//  DetailCoordinatorTests.swift
//  notesTests
//
//  Created by Jan Bednar on 17/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import XCTest
@testable import notes

class DetailCoordinatorTests: XCTestCase {

    let networkClient: NetworkClient = NetworkClientImpl()
    var mockNetworkClient: NetworkClient!
    let navigationController = UINavigationController()
    
    override func setUp() {
        super.setUp()
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }

    func test_afterStart_presentedViewControllerIsDetailControllerAndHasDelegate() {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, networkClient: networkClient, note: nil)
        detailCoordinator.start(animated: false)
        
        let visibleController = navigationController.visibleViewController as? DetailViewController
        
        XCTAssertTrue(visibleController != nil)
        XCTAssertTrue(visibleController?.delegate != nil)
    }

}
