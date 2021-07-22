//
//  PostTimesheet.swift
//  BTSPocket
//
//  Created by bts on 13/07/21.
//

import Foundation

struct TimesheetObject: Codable {
    var date: String?
    var descriptions: [TimesheetDescriptionsObject]?
}
