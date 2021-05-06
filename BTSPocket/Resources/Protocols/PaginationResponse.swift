//
//  Pagination.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

protocol PaginationResponse: Codable {
    var pages: Int? { get set }
    var currentPage: Int? { get set }
}
