//
//  BTSApi.swift
//  BTSPocket
//
//

import UIKit

class BTSApi {
    // Singleton
    static let shared = BTSApi()

    // Session data
    var currentSession: ProfileData?
    var sessionToken: String?
    var sessionProjects: [Project] = []
    
    // Networking models
    lazy var platformEP: BTSPlatformEndpoints = {
        return BTSPlatformEndpoints()
    }()
    
    // MARK: RESET
    func deleteSession() {
        // Delete session data
        self.currentSession = nil
        self.sessionToken = nil
        
        // Remove token
        KeychainWrapper.standard.removeObject(forKey: Constants.Keychain.kSecretToken)
        
        // Remove database data
        RealmAPI.shared.deleteAll()
    }
}
