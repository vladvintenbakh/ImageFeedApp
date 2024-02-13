//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 3/1/24.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    let storageKey = "authToken"
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: storageKey)
        }
        set {
            keychainWrapper.set(newValue ?? "", forKey: storageKey)
        }
    }
    
}
