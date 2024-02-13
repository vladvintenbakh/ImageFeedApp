//
//  ProfileService.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 18/1/24.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username,
                                      name: "\(profileResult.firstName) \(profileResult.lastName ?? "")",
                                      loginName: "@\(profileResult.username)",
                                      bio: profileResult.bio ?? "")
                self.profile = profile
                completion(.success(profile))
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
