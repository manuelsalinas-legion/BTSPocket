//
//  ProfileViewModel.swift
//  BTSPocket
//
//  Created by bts on 12/04/21.
//

import Foundation

struct ProfileViewModel {
    func getProfile(_ completition: @escaping((_ error: NSError?) -> Void ) ) {
        if let userId = BTSApi.shared.currentSession?.id {
            let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
            BTSApi.shared.platformEP.getMethod(urlProfile) { (responseProfile: ProfileResponse) in
                
                if let profileSecion = responseProfile.data {
                    RealmAPI.shared.write(profileSecion.persistenceObject())
                    BTSApi.shared.currentSession = profileSecion
                }
                
                completition(nil)
            } onError: { error in
                completition(error)
            }
        }
    }
    
    func getMemberProfile(_ userId: Int?, _ completition: @escaping( (Result<ProfileData, Error>) -> Void ) ) {
        if let memberId = userId {
            let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(memberId))
            
            BTSApi.shared.platformEP.getMethod(urlProfile) { (responseProfile: ProfileResponse) in
                
                if let profile = responseProfile.data {
                    completition(.success(profile))
                }
            } onError: { error in
                completition(.failure(error))
            }
        }
    }
}
