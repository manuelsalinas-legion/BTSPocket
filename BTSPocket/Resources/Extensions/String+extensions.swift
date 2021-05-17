//
//  String+extension.swift
//  BTSPocket
//
//  Created by Manuel Salinas on 3/25/21.
//

import UIKit

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
    
    //Paragraph
    func toParagraph(lineSpacing: CGFloat = 10, aligned: NSTextAlignment = .center) -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString(string: self)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = aligned

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // *** Set Attributed String to your label ***
        return attributedString
    }
}
