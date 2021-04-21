//
//  ProfileViewModel.swift
//  BTSPocket
//
//  Created by bts on 12/04/21.
//

import Foundation

struct ProfileViewModel {
    func getProfile(_ token: String, _ profileData: ProfileDataRealm, _ completition: @escaping((_ error: NSError?) -> Void ) ) {
        let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(profileData.id))
        let headerAuth = ["Authorization": token]
        BTSApi.shared.platformEP.getMethod(urlProfile, headerAuth) { (responseProfile: ProfileResponse) in
            // mandar a llamar al get profile
            // llenar los datos del get profile con lo que esta en realm
            
            BTSApi.shared.profileSession = responseProfile.data
            completition(nil)
        } onError: { error in
            print(error.localizedDescription)
            completition(error)
        }
    }
}
