//
//  ProfileViewTests.swift
//  ImageFeedAppTests
//
//  Created by Vlad Vintenbakh on 29/2/24.
//

@testable import ImageFeedApp
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerUpdatesInfoLabels() {
        // Given
        let viewController = ProfileViewController()
        let sampleName = "Sample Name"
        let sampleLoginName = "Sample Login Name"
        let sampleBio = "Sample Bio"
        
        // When
        _ = viewController.view
        viewController.updateProfileInfoLabels(name: sampleName,
                                               loginName: sampleLoginName,
                                               bio: sampleBio)
        
        // Then
        XCTAssertEqual(viewController.nameLabel.text, sampleName)
        XCTAssertEqual(viewController.handleLabel.text, sampleLoginName)
        XCTAssertEqual(viewController.descriptionLabel.text, sampleBio)
    }
    
    func testViewControllerSetsUpDescription() {
        // Given
        let viewController = ProfileViewController()
        let expectedText = "Hello, world!"
        let expectedTextColor = UIColor(named: "YPWhite")
        let expectedFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // When
        _ = viewController.view
        viewController.setUpDescriptionLabel()
        
        // Then
        XCTAssertEqual(viewController.descriptionLabel.text, expectedText)
        XCTAssertEqual(viewController.descriptionLabel.textColor, expectedTextColor)
        XCTAssertEqual(viewController.descriptionLabel.font, expectedFont)
    }
}
