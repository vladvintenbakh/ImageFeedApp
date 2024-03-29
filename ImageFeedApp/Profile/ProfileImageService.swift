//
//  ProfileImageService.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 19/1/24.
//

import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        guard let bearerToken = oAuth2TokenStorage.token else { return }
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.large
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
