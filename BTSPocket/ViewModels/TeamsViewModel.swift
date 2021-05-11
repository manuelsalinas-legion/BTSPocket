//
//  TeamsViewModel.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

struct TeamViewModel {
    //Fuction that comes the data of the team in BTS
    func getTeamMembers(_ numberOfPage: Int, _ inputSearch: String?, _ completition: @escaping( (Result<PaginationAllUsers, Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id {
            var url = Constants.Endpoints.getAllUsers + "?page=\(numberOfPage)&status=active&skipId=\(userId)"
            if let inputToSearch = inputSearch,
               inputSearch != ""{
                url.append("&search=\(inputToSearch)")
            }
            BTSApi.shared.platformEP.getMethod(url) { (response: AllUsersReponse) in
                if let paginationUsers = response.data {
                    completition(.success(paginationUsers))
                }
            } onError: { (error) in
                completition(.failure(error))
            }

        }
    }
}
