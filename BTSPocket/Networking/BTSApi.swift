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
    // keychain guardar las credenciales.
    // relacionar credenciales con faceId
    // faceId endpoind que pasa al profile.

    var profileSession: ProfileData?
    var token: String?
    var credentials: Login?
    
    // Lazy netwroking model
    lazy var platformEP: BTSPlatformEndpoints = {
        return BTSPlatformEndpoints()
    }()
    
    // Delete user data
    func deleteUserData() {
        self.profileSession = nil
        self.token = nil
        self.credentials = nil
    }
    
}
