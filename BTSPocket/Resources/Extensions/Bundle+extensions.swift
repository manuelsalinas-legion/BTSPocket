//
//  Bundle+extensions.swift
//  BTSPocket
//
//  Created by Manuel Salinas on 5/11/21.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? String()
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? String()
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber)"
    }

    var versionBuildNumber: String {
        return "V\(releaseVersionNumber) (\(buildVersionNumber))"
    }

    var versionBuildNumberString: String {
        return "\(releaseVersionNumber)-\(buildVersionNumber)"
    }
}
