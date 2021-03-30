//
//  LoguinData.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import Foundation

struct LoginData: Codable {
    var id: Int?
    var permissions: [Permissions?]
    var token: String?
}
