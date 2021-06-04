//
//  HomeTabBarController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.selectedImageTintColor = .btsBlue()
    }
}
