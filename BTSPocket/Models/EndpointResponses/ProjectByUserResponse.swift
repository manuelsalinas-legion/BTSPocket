//
//  ProjectByUserResponse.swift
//  BTSPocket
//
//  Created by bts on 19/05/21.
//

import Foundation

struct ProjectByUserResponse: BackedResponse {
    var status: String?
    var message: String?
    var data: PaginationProjectsFilterByUser?
}
