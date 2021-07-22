//
//  Constants.swift
//  BTSPocket
//
//

import Foundation

// MARK: - GLOBAL CONSTANTS
struct Constants {
    static let kTimeout: TimeInterval = 60
    static var urlBucketImages: String = "https://s3.amazonaws.com/cdn.platform.bluetrail.software/prod/"
    static let serverAddress = "https://platform.bluetrail.software/"
    static let kMinimumCharactersForSearch: Int = 3
    static let hoursWorkingDay: Int = 8
    
    struct Keychain {
        static let kSecretToken = "kSecretToken"
        static let kAuthUsername = "kAuthUsername"
        static let kAuthPassword = "kAuthPassword"
    }
    
    struct Endpoints {
        // User
        static let postAuthentication = "api/users/login"
        static let getUserProfile = "api/users/{userId}/profile"
        static let logoutUser = "api/users/logout"
        static let getAllUsers = "api/users"
        static let userTimesheet = "api/users/{userId}/timesheet"
        
        //Projects
        static let getProjects = "api/projects"
        static let getProjectDetails = "api/projects/"
    }
}

// MARK: - GLOBAL ENUMS
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
