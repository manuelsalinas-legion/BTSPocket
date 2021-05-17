//
//  PaginationAllUsers.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

struct PaginationAllUsers: Codable, PaginationResponse {
    var currentPage: Int?
    var pages: Int?
    var items: [User]?
}
