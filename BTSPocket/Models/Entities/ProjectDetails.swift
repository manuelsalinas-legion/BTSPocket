//
//  ProjectDetails.swift
//  BTSPocket
//
//  Created by bts on 25/05/21.
//

import Foundation

struct ProjectDetails: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let image: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let client: [Client]?
    let activeUsers: [UserInProject]?
    let inactiveUsers: [UserInProject]?
    let activeClientMembers: [ClientMember]?
    let inactiveClientMembers: [ClientMember]?
}
