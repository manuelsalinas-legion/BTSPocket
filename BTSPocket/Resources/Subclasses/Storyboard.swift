//
//

import UIKit

/*
 Add your storyboard names here if needed
 */
enum StoryboardName: String {
    case Main, Popups
}

class Storyboard
{
    ///Get instance from Storyboard
    class func getInstanceOf<T: UIViewController>(_ type: T.Type, in storyboard: StoryboardName = .Main) -> T
    {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
