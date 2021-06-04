//
//  TeamsViewModel.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

enum RequestType {
    case justPage(Int)
    case pageAndFilter(Int, String)
}

struct TeamViewModel {
    
    // Fuction that comes the data of the team in BTS
    func getTeamMembers(_ requestType: RequestType, _ completition: @escaping( (Result<PaginationAllUsers, Error>) -> Void )) {
        var url = Constants.serverAddress + Constants.Endpoints.getAllUsers
        
        if let userId = BTSApi.shared.currentSession?.id {
            // complete the url
            switch requestType {
            case .justPage(let page):
                url.append("?page=\(page)&status=active&skipId=\(userId)")
            case .pageAndFilter(let page, let filter):
                if filter.isEmpty == true {
                    url.append("?page=\(page)&status=active&skipId=\(userId)")
                } else {
                    url.append("?page=\(page)&status=active&skipId=\(userId)&search=\(filter)")
                }
            }
            // call get method
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
