//
//  LoginViewModel.swift
//  BTSPocket
//
//

import Foundation

struct LoginViewModel {
    func login(_ email: String, _ password: String, _ completion: @escaping((_ error: NSError?) -> Void)) {
        let authParams = ["email" : email, "password" : password]
        BTSApi.shared.platformEP.postMethod(Constants.Endpoints.postAuthentication, nil, authParams) { (responseLogin: LoginResponse) in
            
            if let userId = responseLogin.data?.id, let token = responseLogin.data?.token {
                let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
                // inprove way to send token in header
                let headerAuth = ["Authorization": token]
                BTSApi.shared.platformEP.getMethod(urlProfile, headerAuth) {(responseProfile: ProfileResponse) in
                    // save the token here
                    KeychainWrapper.standard.set(token, forKey: "SecretToken")
                    
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
