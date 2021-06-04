//
//  BTSNavigationController.swift
//  BTSPocket
//
//

import UIKit

class BTSNavigationController: UINavigationController {
    // set light status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Color
        self.navigationBar.barTintColor = .btsBlue()
        self.navigationBar.backgroundColor = self.navigationBar.barTintColor
        self.navigationBar.tintColor = .white
        
        // Appearance
        let navBarAppeareance = UINavigationBarAppearance()
        navBarAppeareance.backgroundColor = .btsBlue()
        
        // Font
        if let navbarFont = UIFont(name: "Montserrat-Medium", size: 18) {
            self.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: navbarFont,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            navBarAppeareance.titleTextAttributes = [
                NSAttributedString.Key.font: navbarFont,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        }
        
        self.navigationBar.standardAppearance = navBarAppeareance
        self.navigationBar.scrollEdgeAppearance = navBarAppeareance
    }
}
