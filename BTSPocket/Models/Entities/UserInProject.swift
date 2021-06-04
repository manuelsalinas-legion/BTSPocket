//
//  activeUserInProject.swift
//  BTSPocket
//
//  Created by bts on 21/05/21.
//

import Foundation

struct UserInProject: Codable {
    var id: Int?
    var photo: String?
    var firstName: String?
    var lastName: String?
    var projectRole: String?
    var isLeader: Bool?
    var expectedHoursPerWeek: Int?
    var startDate: String?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
    
    var fullName: String {
        let full = (firstName ?? String()) + " " + (lastName ?? String())
        return full.trim().isEmpty ? "Uknown" : full.capitalized
    }
}
