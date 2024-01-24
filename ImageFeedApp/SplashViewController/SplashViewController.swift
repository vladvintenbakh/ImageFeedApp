//
//  SplashViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 8/1/24.
//

import UIKit
//import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
//    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        KeychainWrapper.standard.removeObject(forKey: "authToken")
        view.backgroundColor = UIColor(named: "YPBlack")
        setUpSplashScreenLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let bearerToken = oAuth2TokenStorage.token {
            profileService.fetchProfile(bearerToken) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    switchToTabBarController()
                    let username = profile.username
                    self.profileImageService.fetchProfileImageURL(username: username) { _ in }
                case .failure:
                    break
                }
            }
        } else {
//            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
            print("About to call switchToAuthViewController")
            switchToAuthViewController()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func setUpSplashScreenLogo() {
        let imageView = UIImageView()
        logoImageView = imageView
        
        imageView.image = UIImage(named: "SplashScreenLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

//extension SplashViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showAuthenticationScreenSegueIdentifier {
//            guard
//                let navigationController = segue.destination as? UINavigationController,
//                let viewController = navigationController.viewControllers[0] as? AuthViewController
//            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//}

extension SplashViewController: AuthViewControllerDelegate {
    private func switchToAuthViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController")
        print("Successfully obtained the auth view controller")
        guard let viewController = viewController as? AuthViewController else { return }
        print("Successfully unwrapped as AuthViewController")
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
    
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
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert(message: "Failed to log in")
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
                self.profileImageService.fetchProfileImageURL(username: username) { _ in }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert(message: "Failed to fetch profile")
                break
            }
        }
    }
    
    private func showNetworkErrorAlert(message: String) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Back to login screen", style: .default) { _ in
            self.switchToAuthViewController()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
