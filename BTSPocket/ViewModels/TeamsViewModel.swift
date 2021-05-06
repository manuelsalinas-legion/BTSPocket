//
//  TeamsViewModel.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

struct TeamViewModel {
    //Fuction that comes the data of the team in BTS
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
