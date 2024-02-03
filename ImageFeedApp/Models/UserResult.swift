//
//  UserResult.swift
//  ImageFeedApp
//
//  Created by Vlad Vintenbakh on 3/2/24.
//

import Foundation

struct ImageSize: Codable {
    let large: String
}

struct UserResult: Codable {
    let profileImage: ImageSize
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
