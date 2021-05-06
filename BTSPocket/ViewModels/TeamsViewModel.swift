//
//  TeamsViewModel.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

struct TeamViewModel {
    //Fuction that comes the data of the team in BTS
    public func getTeamsDemos(_ completition: @escaping((_ team: [User], _ error: NSError?) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id,
           let token = BTSApi.shared.sessionToken {
            let headers = ["Authorization": token]
            let url = Constants.Endpoints.allUsers + "?page=1&status=active&skipId=\(userId)"
            BTSApi.shared.platformEP.getMethod(url, headers) { (response: AllUsersReponse) in
                // ok, aqui tiene que llegar la respuesta de backend que puede ser.
                // ok o error.
                // si es error, saber que error llego y por que variable llega
                // errores 400 a 500 de backend o NSError? que no se bien que es...Investigar
                // y si si?
                // verificar el arreglo
                // como paginar?
                // aumentar arreglo cada pagina.
                // arreglo obtenido aqui. utilizado en teamview controller
                //
                if let paginationUsers = response.data,
                   let allUsers = paginationUsers.items {
                    completition(allUsers, nil)
                }
            } onError: { (error) in
                print(error.localizedDescription)
            }

        }
    }
    
    func getTeamMembers(_ numberOfPage: Int, _ completition: @escaping( (Result<PaginationAllUsers, Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id,
           let token = BTSApi.shared.sessionToken {
            let headers = ["Authorization": token]
            let url = Constants.Endpoints.allUsers + "?page=\(numberOfPage)&status=active&skipId=\(userId)"
            BTSApi.shared.platformEP.getMethod(url, headers) { (response: AllUsersReponse) in
                if let paginationUsers = response.data {
                    completition(.success(paginationUsers))
                }
            } onError: { (error) in
                completition(.failure(error))
            }

        }
    }
}
