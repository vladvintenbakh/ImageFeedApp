//
//  PhotoResult.swift
//  ImageFeedApp
//
//  Created by Vlad Vintenbakh on 5/2/24.
//

import Foundation

struct URLsResult: Codable {
    let full: String
    let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String
    let urls: URLsResult
    let isLikedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLikedByUser = "liked_by_user"
    }
}
