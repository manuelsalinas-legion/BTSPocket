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
        BTSApi.shared.platformEP.postMethod(Constants.Endpoints.postAuthentication, nil, authParams) { (responseLogin: LoginResponse) in
            
            if let userId = responseLogin.data?.id, let token = responseLogin.data?.token {
                let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
                
                let headerAuth = ["Authorization": token]
                BTSApi.shared.platformEP.getMethod(urlProfile, headerAuth) {(responseProfile: ProfileResponse) in
                    
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
