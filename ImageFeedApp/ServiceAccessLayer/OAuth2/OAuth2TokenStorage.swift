//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 3/1/24.
//

import UIKit

final class OAuth2TokenStorage {
    
    let storageKey = "authToken"
    
    private let userDefaults = UserDefaults.standard
    
    var token: String! {
        get {
            userDefaults.string(forKey: storageKey)
        }
        set {
            userDefaults.set(newValue, forKey: storageKey)
        }
    }
    
}
