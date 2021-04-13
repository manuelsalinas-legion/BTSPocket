//
//  SceneDelegate.swift
//  BTSPocket
//
//  Created by bts on 24/03/21.
//

import UIKit

public enum TypeRoot {
    case login, home
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //choose initial ViewController
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let emailKeychain = KeychainWrapper.standard.string(forKey: "authEmail")
        let passwordKeychain = KeychainWrapper.standard.string(forKey: "authPassword")
        KeychainWrapper.standard.removeAllKeys()
        // check if the credentials are in the keychain
        if emailKeychain != nil && passwordKeychain != nil {
            let profileVM: ProfileViewModel = ProfileViewModel()
            profileVM.getProfile { (error) in
                if error != nil {
                    self.switchRoot(to: .login)
                    return
                }
            }
            self.switchRoot(to: .home)
//            let homeVC = storyboard.instantiateViewController(identifier: "HomeTabBarController")
//            let	navController = UINavigationController(rootViewController: homeVC)
//            navController.navigationBar.isTranslucent = false
//            self.window?.rootViewController = navController
        } else {
            switchRoot(to: .login)
        }
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    /// Choose root view controller betwen tabBarHome and Loguin
    func switchRoot(to: TypeRoot) {
        switch to {
        case .home:
            let homeVC: HomeTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeTabBarController") as! HomeTabBarController
            self.window?.rootViewController = homeVC
        case .login:
        let loginVC: LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.window?.rootViewController = loginVC
        }
    }
}

