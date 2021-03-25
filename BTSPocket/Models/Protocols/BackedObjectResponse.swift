//
//  BackedObjectResponse.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import Foundation

protocol BackedObjectResponse: Codable {
    var status: String? { get set }
    var message: String? { get set }
}
