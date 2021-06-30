//
//  GetTimesheets.swift
//  BTSPocket
//
//  Created by bts on 24/06/21.
//

import Foundation

struct GetTimesheets: Codable {
    var id: Int?
    var userId: Int?
    var date: String?
    var createdAt: String?
    var updatedAt: String?
    var descriptions: [TimesheetDescription]?
}
