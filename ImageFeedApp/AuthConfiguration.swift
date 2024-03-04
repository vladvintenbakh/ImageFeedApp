//
//  Constants.swift
//  ImageFeedApp
//
//  Created by Vladislav Vintenbakh on 29/12/23.
//

import UIKit

let accessKeyConstant = "BdibK4ZtiRwEPKhI6EnFNurvHX0vWn7vu_V1R6hPLng"
let secretKeyConstant = "jKty-165oTMC_oir9XBEzV7kSPd9xrt5PUeM2LI_EPY"
let redirectURIConstant = "urn:ietf:wg:oauth:2.0:oob"
let accessScopeConstant = "public+read_user+write_likes"

let defaultBaseURLConstant = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLStringConstant = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: accessKeyConstant,
            secretKey: secretKeyConstant,
            redirectURI: redirectURIConstant,
            accessScope: accessScopeConstant,
            defaultBaseURL: defaultBaseURLConstant,
            authURLString: unsplashAuthorizeURLStringConstant)
    }
    
    init(accessKey: String, 
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURL: URL,
         authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
