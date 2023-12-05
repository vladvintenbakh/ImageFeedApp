//
//  ImageListCell.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 5/12/23.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImageListCell"
    
}
