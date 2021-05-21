//
//  Projet.swift
//  BTSPocket
//
//  Created by bts on 19/05/21.
//

import Foundation

struct Project: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let image: String?
    let startDate: String?
    let endDate: String?
    let clientId: Int?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let users: [Int]?
}
