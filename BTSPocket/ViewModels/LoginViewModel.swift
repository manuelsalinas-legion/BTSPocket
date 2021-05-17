//
//  LoginViewModel.swift
//  BTSPocket
//
//

import Foundation
import UIKit

struct LoginViewModel {
    
    func login(_ email: String, _ password: String, _ completion: @escaping((_ error: NSError?) -> Void)) {
        let authParams = ["email" : email, "password" : password]
        let urlRequest = Constants.serverAddress + Constants.Endpoints.postAuthentication
        BTSApi.shared.platformEP.postMethod(urlRequest, nil, authParams) { (responseLogin: LoginResponse) in
            
            if let userId = responseLogin.data?.id, let token = responseLogin.data?.token {
                let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
                let urlRequest = Constants.serverAddress + urlProfile
                BTSApi.shared.sessionToken = token
                BTSApi.shared.platformEP.getMethod(urlRequest) {(responseProfile: ProfileResponse) in
                    // Save in realm
                    if let profileSecion = responseProfile.data {
                        RealmAPI.shared.write(profileSecion.persistenceObject())
                        BTSApi.shared.currentSession = profileSecion
                        KeychainWrapper.standard.set(token, forKey: Constants.Keychain.kSecretToken)
                    }
                    completion(nil)
                } onError: { error in
                    print(error.localizedDescription)
                    completion(error)
                }
            }
        } onError: { error in
            print(error.localizedDescription)
            completion(error)
        }
    }
}
