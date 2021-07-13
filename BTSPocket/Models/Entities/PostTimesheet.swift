//
//  PostTimesheet.swift
//  BTSPocket
//
//  Created by bts on 13/07/21.
//

import Foundation

struct PostTimesheet: Codable {
    var date: String?
    var descriptions: [PostTimesheetDescriptions]?
}
