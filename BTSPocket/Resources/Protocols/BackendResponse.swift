//
//  BackendResponse.swift
//  BTSPocket
//
//  Created by Manuel Salinas on 3/25/21.
//

import Foundation

protocol BackedResponse: Codable {
    var status: String? { get set }
    var message: String? { get set }
}

