//
//

import Foundation
import UIKit

extension NSMutableAttributedString
{
    //MARK: FONTS
    ///Set Bold and color Style for String
    @discardableResult func setBoldAndColor(_ textToFind: String, color: UIColor, size: CGFloat) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: foundRange)
            self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: size), range: foundRange)
            return true
        }
        return false
    }
    
    ///Set Color in specific String
    @discardableResult func setColor(_ textToFind: String, color: UIColor) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: foundRange)
            return true
        }
        return false
    }
    
    ///Set Color and font in specific String
    @discardableResult func setColor(_ textToFind: String, color: UIColor, font: UIFont) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: foundRange)
            self.addAttribute(NSAttributedString.Key.font, value: font, range: foundRange)
            return true
        }
        return false
    }

    ///Set bold in specific String
    @discardableResult func setBold(_ textToFind: String, size: CGFloat) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: size), range: foundRange)
            return true
        }
        return false
    }
    
    @discardableResult func setBolds(_ words: [String], size: CGFloat) -> Bool
    {
        var foundText = false
        
        for text in words
        {
            let foundRange = self.mutableString.range(of: text)
            if foundRange.location != NSNotFound
            {
                self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: size), range: foundRange)
                foundText = true
            }
        }
        
        return foundText
    }
    
    //Set background color
    @discardableResult func setBackground(_ textToFind: String, color: UIColor) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: foundRange)
            return true
        }
        return false
    }
    
    @discardableResult func setBackgroundColor(_ words: [String], color: UIColor) -> Bool
    {
        var foundText = false
        
        for text in words
        {
            let foundRange = self.mutableString.range(of: text)
            if foundRange.location != NSNotFound
            {
                self.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: foundRange)
                foundText = true
            }
        }
        
        return foundText
    }
    
    ///Set Italic in specific String
    @discardableResult func setItalic(_ textToFind: String, size: CGFloat) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: size), range: foundRange)
            return true
        }
        
        return false
    }
    
    ///Set bold in specific String
    func setBoldColorFont(_ textToFind: String, size: CGFloat, color: UIColor, font: UIFont) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: size), range: foundRange)
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: foundRange)
            self.addAttribute(NSAttributedString.Key.font, value: font, range: foundRange)
            
            return true
        }
        
        return false
    }
    
    ///Set underline with size, bold and color in specific String
    @discardableResult func setUnderline(_ textToFind: String, size: CGFloat, color: UIColor, bold: Bool) -> Bool
    {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: foundRange)
            self.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: foundRange)
            
            if bold == true
            {
                self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: size), range: foundRange)
                
            }
            else
            {
                self.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: size), range: foundRange)
            }
            
            return true
        }
        return false
    }
}
