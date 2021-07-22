//
//  UIViewController+extensions.swift
//  BTSPocket
//
//  Created by bts on 23/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func logout(expiredSession: Bool) {
        BTSApi.shared.deleteSession()
        self.showLogin(expiredSession)
    }
    
    func showLogin(_ expiredSession: Bool) {
        DispatchQueue.main.async {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.switchRoot(to: .login(expiredSession))
        }
    }
    
    func backButtonArrow() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
