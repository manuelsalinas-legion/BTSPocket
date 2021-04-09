//
//

import UIKit

extension NSAttributedString {
    class func getAttributedSecondaryTitle(_ title: String?, subtitle: String?, fontSize: CGFloat) -> NSAttributedString {
        let titleAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize),
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        let subtitleAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize - 2),
                             NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        let resultingString = NSMutableAttributedString()
        
        if let title = title {
            let attributedTitle = NSMutableAttributedString(string: title, attributes: titleAttrs)
            resultingString.append(attributedTitle)
        }
        
        if let subtitle = subtitle {
            resultingString.append(NSAttributedString(string: "\n"))
            
            let attributedSubtitle = NSMutableAttributedString(string: subtitle, attributes: subtitleAttrs)
            resultingString.append(attributedSubtitle)
        }
        
        return resultingString
    }
}
