//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 20/12/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var profileImageView: UIImageView!
    private var nameLabel: UILabel!
    private var handleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfileImage()
        setUpNameLabel()
        setUpHandleLabel()
        setUpDescriptionLabel()
        setUpLogoutButton()
    }
    
    private func setUpProfileImage() {
        let imageView = UIImageView()
        profileImageView = imageView
        
        imageView.image = UIImage(named: "Profile Picture")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
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
    
    private func setUpDescriptionLabel() {
        let label = UILabel()
        descriptionLabel = label
        
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    @objc
    private func didPressLogoutButton() {
        
    }
}

