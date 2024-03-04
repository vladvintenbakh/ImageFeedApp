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
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(_ code: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        var pathString = "/oauth/token"
        pathString += "?client_id=\(accessKeyConstant)"
        pathString += "&&client_secret=\(secretKeyConstant)"
        pathString += "&&redirect_uri=\(redirectURIConstant)"
        pathString += "&&code=\(code)"
        pathString += "&&grant_type=authorization_code"
        let url = URL(string: "https://unsplash.com")
        return URLRequest.makeHTTPRequest(path: pathString, httpMethod: "POST", baseURL: url!)
    }
}
