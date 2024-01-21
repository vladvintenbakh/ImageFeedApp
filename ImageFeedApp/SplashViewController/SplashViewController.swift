//
//  SplashViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 8/1/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let bearerToken = oAuth2TokenStorage.token {
            profileService.fetchProfile(bearerToken) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    switchToTabBarController()
                    let username = profile.username
                    self.profileImageService.fetchProfileImageURL(username: username) { _ in
                        print("Profile image retrieved outside of the authorization process")
                        print("Profile image URL: \(self.profileImageService.avatarURL ?? "")")
                    }
                case .failure:
                    break
                }
            }
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
                let username = profile.username
                self.profileImageService.fetchProfileImageURL(username: username) { _ in
                    print("Profile image retrieved in the authorization process")
                    print("Profile image URL: \(self.profileImageService.avatarURL ?? "")")
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert()
                break
            }
        }
    }
    
    private func showNetworkErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong", message: "Failed to log in", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
