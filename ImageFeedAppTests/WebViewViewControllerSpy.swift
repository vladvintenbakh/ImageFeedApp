//
//  WebViewViewControllerSpy.swift
//  ImageFeedAppTests
//
//  Created by Vlad Vintenbakh on 22/2/24.
//

@testable import ImageFeedApp
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled: Bool = false
    var presenter: ImageFeedApp.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
