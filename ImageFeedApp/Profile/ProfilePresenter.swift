//
//  ProfilePresenter.swift
//  ImageFeedApp
//
//  Created by Vlad Vintenbakh on 29/2/24.
//

import UIKit
import SwiftKeychainWrapper
import WebKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetails()
    func updateAvatar()
    func logoutConfirmed()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()
            }
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileInfoLabels(name: profile.name,
                                      loginName: profile.loginName,
                                      bio: profile.bio)
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let avatarURL = URL(string: profileImageURL)
        else { return }
        view?.updateProfileAvatar(avatarURL: avatarURL)
    }
    
    func logoutConfirmed() {
        KeychainWrapper.standard.removeObject(
            forKey: self.oAuth2TokenStorage.storageKey
        )
        clearCookies()
        switchToSplashViewController()
    }
    
    private func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes,
                                                        for: [record],
                                                        completionHandler: {})
            }
        }
    }
    
    private func switchToSplashViewController() {
        let splashViewController = SplashViewController()
        view?.navigateToSplashScreen(splashViewController)
    }
}
