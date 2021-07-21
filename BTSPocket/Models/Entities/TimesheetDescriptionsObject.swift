//
//  PostTimesheetDescriptions.swift
//  BTSPocket
//
//  Created by bts on 12/07/21.
//

import Foundation

struct TimesheetDescriptionsObject: Codable {
    var projectId: Int?
    var dedicatedHours: Int?
    var task: String?
    var isHappy: Bool?
    var note: String?
    var projectName: String?
    
    
    func getDiccionary() -> [String: Any] {
        var dict: [String : Any] = [:]
        dict += ["projectId": self.projectId ?? nil]
        dict += ["dedicatedHours": self.dedicatedHours ?? 0]
        dict += ["task": self.task ?? ""]
        dict += ["isHappy": self.isHappy ?? true]
        dict += ["note": note ?? "Test"]
        return dict
    }
    
    func isReady() -> Bool {
        return dedicatedHours != nil
            && isHappy != nil
            && projectId != nil
            && task != nil
    }
}
