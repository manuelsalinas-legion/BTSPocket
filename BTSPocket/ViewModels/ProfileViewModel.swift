//
//  ProfileViewModel.swift
//  BTSPocket
//
//  Created by bts on 12/04/21.
//

import Foundation

struct ProfileViewModel {
    func getProfile(_ completition: @escaping((_ error: NSError?) -> Void ) ) {
        if let userId = BTSApi.shared.currentSession?.id,
           let token = BTSApi.shared.sessionToken {
            let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
            let headerAuth = ["Authorization": token]
            BTSApi.shared.platformEP.getMethod(urlProfile, headerAuth) { (responseProfile: ProfileResponse) in
                
                if let profileSecion = responseProfile.data {
                    RealmAPI.shared.write(profileSecion.persistenceObject())
                    BTSApi.shared.currentSession = profileSecion
                }
                
                completition(nil)
            } onError: { error in
                print(error.localizedDescription)
                completition(error)
            }

        }
    }
    
    func logout(_ completition: @escaping((_ error: NSError?) -> Void )) {
        if let token = BTSApi.shared.sessionToken {
            let headerAuth = ["Authorization": token]
            
        }
    }
}
