//
//  Projet.swift
//  BTSPocket
//
//  Created by bts on 19/05/21.
//

import Foundation

struct Project: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var image: String?
    var startDate: String?
    var endDate: String?
    var clientId: Int?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
    var users: [Int]?
}
