//
//  ViewController.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 1/12/23.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImageListService()
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
        imageListService.fetchPhotosNextPage()
//        updateTableViewAnimated()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoNames[indexPath.row]) // change this to work with the kf loaded photos too
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == numberOfRows - 1 {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let thumbnailURL = URL(string: photo.thumbImageURL) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: thumbnailURL, 
                                   placeholder: UIImage(named: "FeedImagePlaceholder")) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let currentDate = Date()
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        
        let likeImage = photo.isLiked ? UIImage(named: "Active Like") : UIImage(named: "Inactive Like")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        cell.delegate = self
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                // TODO: display the error message using UIAlertController
            }
        }
    }
}
