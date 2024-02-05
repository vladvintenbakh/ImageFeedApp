//
//  ImageListService.swift
//  ImageFeedApp
//
//  Created by Vlad Vintenbakh on 3/2/24.
//

import Foundation

final class ImageListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let imageListURL = defaultBaseURL.absoluteString + "/photos"
        var urlComponents = URLComponents(string: imageListURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
        ]
        guard let finalUrl = urlComponents?.url else { fatalError("Failed to create URL from components") }
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        guard let bearerToken = oAuth2TokenStorage.token else { return }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
                
            case .success(let photoResultList):
                
                for photoResult in photoResultList {
                    
                    let photoSize = CGSize(width: Double(photoResult.width),
                                           height: Double(photoResult.height))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    var photoCreatedDate: Date?
                    if let parsedDate = photoResult.createdAt {
                        photoCreatedDate = dateFormatter.date(from: parsedDate)
                    }
                    
                    let photo = Photo(
                        id: photoResult.id,
                        size: photoSize,
                        createdAt: photoCreatedDate,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.isLikedByUser)
                    
                    self.photos.append(photo)
                }
                
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: self)
                
                self.task = nil
                
            case .failure(let error):
                print("Failed with error: \(error)")
                self.task = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}

//func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
//    assert(Thread.isMainThread)
//    task?.cancel()
//    var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
//    guard let bearerToken = oAuth2TokenStorage.token else { return }
//    request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//    let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
//        switch result {
//        case .success(let userResult):
//            let avatarURL = userResult.profileImage.large
//            self.avatarURL = avatarURL
//            completion(.success(avatarURL))
//            NotificationCenter.default.post(
//                name: ProfileImageService.didChangeNotification,
//                object: self,
//                userInfo: ["URL": avatarURL])
//            self.task = nil
//        case .failure(let error):
//            completion(.failure(error))
//            self.task = nil
//        }
//    }
//    self.task = task
//    task.resume()
//}
