//
//  ProfileViewModel.swift
//  BTSPocket
//
//  Created by bts on 12/04/21.
//

import Foundation

struct ProfileViewModel {
    func getProfile(_ completition: @escaping((_ error: NSError?) -> Void ) ) {
        // obtener el perfil
        // el id se debe de guardar en el keychain?
        if let userId = KeychainWrapper.standard.integer(forKey: "id") {
            let urlProfile = Constants.Endpoints.getUserProfile.replacingOccurrences(of: "{userId}", with: String(userId))
            BTSApi.shared.platformEP.getMethod(urlProfile) { (responseProfile: ProfileResponse) in
                
                BTSApi.shared.profileSession = responseProfile.data
                completition(nil)
            } onError: { error in
                print(error.localizedDescription)
                completition(error)
                // si falla mostrar loguin desde aqui??
                // mostrar alerta de sesion caducada?
                // eliminar profile sesion
                // eliminar credentials
            }

        }
    }
}
