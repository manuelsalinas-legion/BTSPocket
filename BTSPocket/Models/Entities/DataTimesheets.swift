//
//  DataTimesheets.swift
//  BTSPocket
//
//  Created by bts on 24/06/21.
//

import Foundation

struct DataTimesheets: Codable {
    let holidays: [String?]?
    let timesheets: [GetTimesheets]?
}
