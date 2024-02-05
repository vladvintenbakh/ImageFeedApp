//
//  Photo.swift
//  ImageFeedApp
//
//  Created by Vlad Vintenbakh on 3/2/24.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
