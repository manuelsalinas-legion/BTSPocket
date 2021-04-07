//
//  LoginViewModel.swift
//  BTSPocket
//
//

import Foundation
import UIKit

struct LoginViewModel {
    private let kSECRET_TOKEN = "SecretToken"
    
    func login(_ email: String, _ password: String, _ completion: @escaping((_ error: NSError?) -> Void)) {
        let authParams = ["email" : "cristianp@bluetrailsoft.com", "password" : "Ch1rr1z."]
        BTSApi.shared.platformEP.postMethod(Constants.Endpoints.postAuthentication, nil, authParams) { (responseLogin: LoginResponse) in
            
            if let userId = responseLogin.data?.id, let token = responseLogin.data?.token {
                let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
                
                let headerAuth = ["Authorization": token]
                BTSApi.shared.platformEP.getMethod(urlProfile, headerAuth) {(responseProfile: ProfileResponse) in
                    
                    KeychainWrapper.standard.set(token, forKey: kSECRET_TOKEN)
                    
                    BTSApi.shared.profileSession = responseProfile.data
                    
                    completion(nil)
                } onError: { error in
                    print(error.localizedDescription)
                    completion(error)
                }
            }
            completion(nil)
        } onError: { error in
            print(error.localizedDescription)
            completion(error)
        }
    }
}
