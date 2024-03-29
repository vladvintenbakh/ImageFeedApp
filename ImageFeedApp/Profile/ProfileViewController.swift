//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 20/12/23.
//

import UIKit
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileInfoLabels(name: String, loginName: String, bio: String)
    func updateProfileAvatar(avatarURL: URL)
    func showProfileLogoutConfirmationAlert()
    func navigateToSplashScreen(_ destinationScreen: UIViewController)
}

class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    private var profileImageView: UIImageView!
    var nameLabel: UILabel!
    var handleLabel: UILabel!
    var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfileImage()
        setUpNameLabel()
        setUpHandleLabel()
        setUpDescriptionLabel()
        setUpLogoutButton()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    private func setUpProfileImage() {
        let imageView = UIImageView()
        profileImageView = imageView
        
        imageView.image = UIImage(named: "Profile Picture")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        ])
    }
    
    private func setUpNameLabel() {
        let label = UILabel()
        nameLabel = label
        
        label.text = "Jane Doe"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "YPWhite")
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
        ])
    }
    
    private func setUpHandleLabel() {
        let label = UILabel()
        handleLabel = label
        
        label.text = "@jane_doe"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "YPGray")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
    }
    
    func setUpDescriptionLabel() {
        let label = UILabel()
        descriptionLabel = label
        
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor(named: "YPWhite")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            label.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
    }
    
    private func setUpLogoutButton() {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(didPressLogoutButton))
        button.accessibilityIdentifier = "LogoutButton"
        logoutButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "YPRed")
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 16),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: profileImageView.trailingAnchor),
        ])
    }
    
    func updateProfileInfoLabels(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        handleLabel.text = loginName
        descriptionLabel.text = bio
    }
    
    func updateProfileAvatar(avatarURL: URL) {
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: avatarURL,
                                     options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    @objc
    private func didPressLogoutButton() {
        showProfileLogoutConfirmationAlert()
    }
    
    func showProfileLogoutConfirmationAlert() {
        let alert = UIAlertController(title: "Confirm logout?",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "LogoutConfirmationAlert"
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.presenter?.logoutConfirmed()
        }
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToSplashScreen(_ destinationScreen: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = destinationScreen
    }
}
