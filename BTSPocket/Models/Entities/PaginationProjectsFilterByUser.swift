//
//  PaginationProjectsFilterByUser.swift
//  BTSPocket
//
//  Created by bts on 19/05/21.
//

import Foundation

struct PaginationProjectsFilterByUser: Codable, PaginationResponse {
    var pages: Int?
    var currentPage: Int?
    var items: [Project]?
}
