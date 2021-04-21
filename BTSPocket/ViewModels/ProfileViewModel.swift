//
//  ProfileViewModel.swift
//  BTSPocket
//
//  Created by bts on 12/04/21.
//

import Foundation

struct ProfileViewModel {
    func getProfile(_ token: String, _ completition: @escaping((_ error: NSError?) -> Void ) ) {
        if let userId = KeychainWrapper.standard.integer(forKey: "id") {
            let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
            let headerAuth = ["Authorization": token]
            BTSApi.shared.platformEP.getMethod(urlProfile, headerAuth) { (responseProfile: ProfileResponse) in
                print(responseProfile)
                BTSApi.shared.currentSession = responseProfile.data
                completition(nil)
            } onError: { error in
                print(error.localizedDescription)
                completition(error)
            }

        }
    }
}
