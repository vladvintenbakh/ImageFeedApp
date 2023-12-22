//
//  SingleImageViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 22/12/23.
//

import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        imageView.image = image
    }
    
    @IBAction func didPressBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
