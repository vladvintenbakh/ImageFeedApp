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
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        var urlComponents = URLComponents(string: defaultBaseURL.absoluteString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
        ]
        guard let finalUrl = urlComponents?.url else { fatalError("Failed to create URL from components") }
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResultList):
                // TODO: convert to Photo, update the photos array, post notification
                let firstPhoto = photoResultList[0]
                print(firstPhoto.urls.full)
            case .failure(let error):
                // TODO: clean up based on the requirements
                print("Failed with error: \(error)")
                break
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
