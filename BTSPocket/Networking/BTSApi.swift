//
//  BTSApi.swift
//  BTSPocket
//
//

import UIKit

class BTSApi {
    // Singleton
    static let shared = BTSApi()
    
    // Lazy netwroking model
    lazy var platformEP: BTSPlatformEndpoints = {
        return BTSPlatformEndpoints()
    }()
}
