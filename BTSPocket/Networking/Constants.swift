//
//  Constants.swift
//  BTSPocket
//
//

import Foundation

struct Constants {
    static let kTimeout: TimeInterval = 60
    
    struct Endpoints {
        static let postAuthentication = "https://platform.bluetrail.software/api/users/login"
        static let getUserProfile = "https://platform.bluetrail.software/api/users/{userId}/profile"
        static let serverAddress = "https://platform.bluetrail.software/"
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
