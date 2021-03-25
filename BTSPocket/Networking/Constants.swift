//
//  Constants.swift
//  BTSPocket
//
//

import Foundation

struct Constants {
    static let kTimeout: TimeInterval = 60
    
    struct Endpoints {
        static let authentication = "https://platform.bluetrail.software/api/users/login"
    }
}

// MARK:- GLOBAL ENUMS
enum HttpStatusCode: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case timeout = 408
}
