//
//  APIResponse.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import Foundation

protocol BackedResponse: Codable {
    var message: String? { get set }
    var status: String? { get set }
}
