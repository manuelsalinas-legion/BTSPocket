//
//  ProjectsViewModel.swift
//  BTSPocket
//
//  Created by bts on 18/05/21.
//

import Foundation

struct ProjectsViewModel {
    func getProjectsByUser(_ requestType: RequestType, _ completition: @escaping( (Result<PaginationProjectsFilterByUser, Error>) -> Void )) {
        if let userId = BTSApi.shared.currentSession?.id {
            var url = Constants.serverAddress + Constants.Endpoints.getProjects + "?involved=\(userId)"
            
            switch requestType {
            case .justPage(let page):
                url.append("&page=\(page)")
            case .pageAndFilter(let page, let text):
                if text.isEmpty == true {
                    url.append("&page=\(page)")
                } else {
                    url.append("&page=\(page)&search=\(text)")
                }
            }
            
            BTSApi.shared.platformEP.getMethod(url) { (response: ProjectByUserResponse) in
                if let paginationProgects = response.data {
                    completition(.success(paginationProgects))
                }
            } onError: { (error) in
                completition(.failure(error))
            }

        }
    }
}
