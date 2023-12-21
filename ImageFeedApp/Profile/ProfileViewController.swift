//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 20/12/23.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton() {
        
    }
}

