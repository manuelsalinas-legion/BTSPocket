//
//  Users.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

struct User: Codable {
    var id: Int?
    var fullName: String?
    var seniorityPosition: String?
    var firstName: String?
    var lastName: String?
    var photo: String?
    var startDate: String?
    var endDate: String?
    var companyField: String?
    var companyLocation: String?
}
