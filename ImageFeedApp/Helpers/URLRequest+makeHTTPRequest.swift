//
//  URLRequest+makeHTTPRequest.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 1/1/24.
//

import UIKit

extension URLRequest {
    static func makeHTTPRequest(path: String,
                                httpMethod: String,
                                baseURL: URL = defaultBaseURLConstant) -> URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod
        return request
    }
}
