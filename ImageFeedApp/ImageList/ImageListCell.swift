//
//  ImageListCell.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 5/12/23.
//

import UIKit

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    static let reuseIdentifier = "ImageListCell"
    
    weak var delegate: ImageListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            let activeLikeImage = UIImage(named: "Active Like")
            likeButton.setImage(activeLikeImage, for: .normal)
        } else {
            let inactiveLikeImage = UIImage(named: "Inactive Like")
            likeButton.setImage(inactiveLikeImage, for: .normal)
        }
    }
}
