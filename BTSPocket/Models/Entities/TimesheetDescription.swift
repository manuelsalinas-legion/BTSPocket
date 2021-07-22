//
//  TimesheetDescription.swift
//  BTSPocket
//
//  Created by bts on 24/06/21.
//

import Foundation

struct TimesheetDescription: Codable {
    var id: Int?
    var timesheetId: Int?
    var projectId: Int?
    var dedicatedHours: Int?
    var task: String?
    var isHappy: Bool?
    var note: String?
    var createdAt: String?
    var updatedAt: String?
    var projectName: String?
}
