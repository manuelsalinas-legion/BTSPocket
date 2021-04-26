//
//  ProfileResponse.swift
//  BTSPocket
//
//  Created by bts on 30/03/21.
//

import Foundation

struct ProfileResponse: BackedResponse {
    var status: String?
    var message: String?
    var data: ProfileData?
}
