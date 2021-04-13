//
//  ProfileData.swift
//  BTSPocket
//
//  Created by bts on 27/03/21.
//

import Foundation

struct ProfileData: Codable {
    var id: Int?
    var description: String?
    var lastName: String?
    var firstName: String?
    var position: String?
    var field: String?
    var location: String?
    var seniority: String?
    var region: String?
    var startDate: String?
    var email: String?
    var photo: String?
    var experiences: [Experience]?
    var skills: [Skill]?
    // convertir how to create date from string
//    var starts: Date { return Date(startDate) }
}
