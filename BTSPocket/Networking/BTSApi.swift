//
//  BTSApi.swift
//  BTSPocket
//
//

import UIKit

class BTSApi {
    // Singleton
    static let shared = BTSApi()

    var profileSession: ProfileData?
    var token: String?
    var credentials: Login?
    private let kSECRET_TOKEN = "SecretToken"
    
    // Lazy netwroking model
    lazy var platformEP: BTSPlatformEndpoints = {
        return BTSPlatformEndpoints()
    }()
    
    // Delete user data
    func deleteUserData() {
        self.profileSession = nil
        self.token = nil
        self.credentials = nil
        KeychainWrapper.standard.removeObject(forKey: kSECRET_TOKEN)
        KeychainWrapper.standard.removeObject(forKey: "id")
        DispatchQueue.main.async {
            let sceneDelegateVariable = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegateVariable?.switchRoot(to: .login)
        }
    }
    
}
