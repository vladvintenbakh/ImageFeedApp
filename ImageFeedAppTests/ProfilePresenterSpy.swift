//
//  ProfilePresenterSpy.swift
//  ImageFeedAppTests
//
//  Created by Vlad Vintenbakh on 29/2/24.
//

@testable import ImageFeedApp
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled = false
    var view: ImageFeedApp.ProfileViewProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfileDetails() {
        
    }
    
    func updateAvatar() {
        
    }
    
    func logoutConfirmed() {
        
    }
}
