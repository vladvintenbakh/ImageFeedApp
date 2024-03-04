//
//  WebViewPresenterSpy.swift
//  ImageFeedAppTests
//
//  Created by Vlad Vintenbakh on 22/2/24.
//

@testable import ImageFeedApp
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
