//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Vlad Vintenbakh on 22/2/24.
//

@testable import ImageFeedApp
import XCTest

final class ImageFeedAppTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "WebViewViewController"
        ) as! WebViewViewController
        
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // Given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
}
