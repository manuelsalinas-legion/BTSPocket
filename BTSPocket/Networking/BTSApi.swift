//
//  BTSApi.swift
//  BTSPocket
//
//

import UIKit

class BTSApi {
    // Singleton
    static let shared = BTSApi()
    
    // user profile information from BE
    var profileSession: ProfileData?
    var token: String?
    
    // Lazy netwroking model
    lazy var platformEP: BTSPlatformEndpoints = {
        return BTSPlatformEndpoints()
    }()
}
