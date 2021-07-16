//
//  PostTimesheetDescriptions.swift
//  BTSPocket
//
//  Created by bts on 12/07/21.
//

import Foundation

struct TimesheetDescriptionsObject: Codable {
    var dedicatedHours: Int?
    var isHappy: Bool?
    var projectId: Int?
    var task: String?
    var note: String?
    
    func getDiccionary() -> [String: Any] {
        var dict: [String : Any] = [:]
        dict += ["dedicatedHours": self.dedicatedHours ?? 0]
        dict += ["isHappy": self.isHappy ?? true]
        dict += ["projectId": self.projectId ?? nil]
        dict += ["task": self.task ?? ""]
//        if let note = self.note, !note.isEmpty {
            dict += ["note": note ?? "Test"]
//        }
        return dict
    }
}
