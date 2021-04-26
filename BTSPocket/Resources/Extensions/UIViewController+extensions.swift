//
//  UIViewController+extensions.swift
//  BTSPocket
//
//  Created by bts on 23/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showLogin() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.switchRoot(to: .login)
    }
}
