//
//  LoguinResponse.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import Foundation

struct LoginResponse: BackedResponse {
    var status: String?
    
    var message: String?
    
    var data: LoginData?
    
}
