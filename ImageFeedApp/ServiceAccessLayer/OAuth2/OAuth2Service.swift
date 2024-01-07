//
//  JSONResponseProcessing.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 1/1/24.
//

import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(_ code: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                print("Auth Token has been obtained: \(authToken)")
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        var pathString = "/oauth/token"
        pathString += "?client_id=\(accessKey)"
        pathString += "&&client_secret=\(secretKey)"
        pathString += "&&redirect_uri=\(redirectURI)"
        pathString += "&&code=\(code)"
        pathString += "&&grant_type=authorization_code"
        let url = URL(string: "https://unsplash.com")
        return URLRequest.makeHTTPRequest(path: pathString, httpMethod: "POST", baseURL: url!)
    }
    
    private struct OAuthTokenResponseBody: Codable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}
