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
   
    #warning("Why do you expose this info?")
    var credentials: Login?
    
    // Networking models
    lazy var platformEP: BTSPlatformEndpoints = {
        return BTSPlatformEndpoints()
    }()
    
    // MARK: RESET
    func deleteSession() {
        // Delete session data
        self.currentSession = nil
        self.sessionToken = nil
        self.credentials = nil
        
        // Remove token
        KeychainWrapper.standard.removeObject(forKey: Constants.Keychain.kSecretToken)
        
        #warning("What is id? / why did you conosider this info should be inside keychain?")
        KeychainWrapper.standard.removeObject(forKey: "id")
        
        // Remove database data
        RealmAPI.shared.deleteAll()
    }
}
