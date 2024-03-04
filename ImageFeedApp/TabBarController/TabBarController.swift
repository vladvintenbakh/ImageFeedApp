//
//  TabBarController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 23/1/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfilePresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewController.view.backgroundColor = UIColor(named: "YPBlack")
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "Profile Tab Active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
    
}
