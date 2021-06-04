//
//  ProjectDetailsResponse.swift
//  BTSPocket
//
//  Created by bts on 25/05/21.
//

import Foundation

struct ProjectDetailsResponse: BackedResponse {
    var status: String?
    var message: String?
    var data: ProjectDetails?
}
