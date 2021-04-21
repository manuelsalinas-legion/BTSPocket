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
        
        if let result = RealmAPI.shared.select(className: ProfileDataRealm.self, predicate: nil) as? [ProfileDataRealm],
           let sessionResult = result.first {
            // Persistent token in keychain?
            if let tokenChain = KeychainWrapper.standard.string(forKey: Constants.Keychain.kSecretToken) {
                
                // Recover and set session data
                BTSApi.shared.currentSession = ProfileData(realmObject: sessionResult)
                BTSApi.shared.sessionToken = tokenChain
                
                // Go home
                self.switchRoot(to: .home)
            } else {
                // Remove data and show login
                BTSApi.shared.deleteSession()
                switchRoot(to: .login)
            }
        } else {
            // Remove data and show login
            BTSApi.shared.deleteSession()
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
}

// MARK: - ROOT SWITCHER
extension SceneDelegate {
    func switchRoot(to: TypeRoot) {
        switch to {
        case .home:
            self.window?.rootViewController = Storyboard.getInstanceOf(HomeTabBarController.self)
        case .login:
            self.window?.rootViewController = Storyboard.getInstanceOf(LoginViewController.self)
        }
    }
}

