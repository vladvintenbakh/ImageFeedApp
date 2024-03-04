//
//  ImageListTests.swift
//  ImageFeedAppTests
//
//  Created by Vlad Vintenbakh on 2/3/24.
//

@testable import ImageFeedApp
import XCTest

final class ImageListTests: XCTestCase {
    func testInitialConfiguration() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController
        
        // When
        _ = imageListViewController.view
        
        // Then
        XCTAssertNotNil(imageListViewController.tableView)
        XCTAssertTrue(imageListViewController.photos.isEmpty)
    }
    
    func testTableViewInsets() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController
        let expectedInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        // When
        _ = imageListViewController.view
        
        // Then
        XCTAssertEqual(imageListViewController.tableView.contentInset,
                       expectedInsets)
    }
    
    func testNumberOfRowsInSection() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImageListViewController
        let mockPhoto = Photo(id: "1234",
                              size: CGSize(width: 100.0, height: 100.0),
                              createdAt: nil,
                              welcomeDescription: nil,
                              thumbImageURL: "",
                              largeImageURL: "",
                              isLiked: false)
        
        // When
        _ = imageListViewController.view
        imageListViewController.photos = [mockPhoto]
        
        // Then
        XCTAssertEqual(
            imageListViewController.tableView(imageListViewController.tableView,
                                              numberOfRowsInSection: 0), 1)
    }
}
