//
//  String+extension.swift
//  BTSPocket
//
//  Created by Manuel Salinas on 3/25/21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func trim() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespaces)
        let filtered = components.filter({ $0.isEmpty == false })

        return filtered.joined(separator: " ")
    }
}
