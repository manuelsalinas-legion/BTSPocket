//
//  DataTimesheets.swift
//  BTSPocket
//
//  Created by bts on 24/06/21.
//

import Foundation

struct DataTimesheets: Codable {
    var holidays: [String?]?
    var timesheets: [Timesheet]?
}
