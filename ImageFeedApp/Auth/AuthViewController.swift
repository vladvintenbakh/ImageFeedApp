//
//  AuthViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 30/12/23.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let sharedAuthService = OAuth2Service.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        
        // TODO: move this to the splash screen file
//        print("fetchAuthToken about to be called")
//        sharedAuthService.fetchAuthToken(code) { result in
//            switch result {
//            case .success(let bearerToken):
//                print("Successfully obtained and saved the token: \(bearerToken)")
//            case .failure(let error):
//                print("Failed to obtain the token with the following error: \(error)")
//            }
//        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
