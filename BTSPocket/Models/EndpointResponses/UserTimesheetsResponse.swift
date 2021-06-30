//
//  UserTimesheetsResponse.swift
//  BTSPocket
//
//  Created by bts on 24/06/21.
//

import Foundation

struct UserTimesheetsResponse: BackedResponse {
    var status: String?
    var message: String?
    var data: DataTimesheets?
}
