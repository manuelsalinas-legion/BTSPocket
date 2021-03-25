//
//  Dictionary+extension.swift
//  BTSPocket
//
//

import Foundation

extension Dictionary {
    var prettyJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch _ {
            return nil
        }
    }
}

extension Dictionary where Key == String {
    subscript(caseInsensitive key: Key) -> Value? {
        get {
            if let firstKey = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                return self[firstKey]
            }
            return nil
        }
        set {
            if let firstKey = keys.first(where: { $0.caseInsensitiveCompare(key) == .orderedSame }) {
                self[firstKey] = newValue
            } else {
                self[key] = newValue
            }
        }
    }
}

