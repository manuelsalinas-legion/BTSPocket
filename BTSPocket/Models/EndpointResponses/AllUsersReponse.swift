//
//  AllUsersReponse.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import Foundation

struct AllUsersReponse: BackedResponse {
    var status: String?
    var message: String?
    var data: PaginationAllUsers?
}
