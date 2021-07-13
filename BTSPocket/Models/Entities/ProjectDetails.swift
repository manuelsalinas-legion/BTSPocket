//
//  ProjectDetails.swift
//  BTSPocket
//
//  Created by bts on 25/05/21.
//

import Foundation

struct ProjectDetails: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var image: String?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
    var client: [Client]?
    var activeUsers: [UserInProject]?
    var inactiveUsers: [UserInProject]?
    var activeClientMembers: [ClientMember]?
    var inactiveClientMembers: [ClientMember]?
}
