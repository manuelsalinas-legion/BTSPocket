//
//  Experience.swift
//  BTSPocket
//
//  Created by bts on 30/03/21.
//

import Foundation

struct Experience: Codable {
    var id: Int?
    var location: String?
    var position: String?
    var responsibilities: [String?]
    var company: String?
    var fromDate: String?
    var toDate: String?
}
