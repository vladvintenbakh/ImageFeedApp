//
//  ProfileService.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 18/1/24.
//

import UIKit

final class ProfileService {
    
    private let urlSession = URLSession.shared
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        // TODO: prevent possible race condition
        print("ProfileService.fetchProfile started executing")
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Request ready")
        let task = object(for: request) { result in
            switch result {
            case .success(let profileResult):
                print("Successfully retrieved profile result for name: \(profileResult.firstName)")
                let profile = Profile(username: profileResult.username,
                                      name: "\(profileResult.firstName) \(profileResult.lastName)",
                                      loginName: "@\(profileResult.username)",
                                      bio: profileResult.bio)
                completion(.success(profile))
            case .failure(let error):
                print("Failed profile retrieval with error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension ProfileService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    private struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
}
