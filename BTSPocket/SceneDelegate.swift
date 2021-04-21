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
    private let kSECRET_TOKEN = "SecretToken"
    private var profileVM: ProfileViewModel?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        KeychainWrapper.standard.removeAllKeys()
        //choose initial ViewController
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        if let result = RealmAPI.shared.select(className: ProfileDataRealm.self, predicate: nil) as? [ProfileDataRealm], let sessionResult = result.first {
            // check if the credentials are in the keychain
            if let tokenChain = KeychainWrapper.standard.string(forKey: kSECRET_TOKEN) {
                self.profileVM = ProfileViewModel()
                self.profileVM?.getProfile(tokenChain, sessionResult) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.switchRoot(to: .login)
                        return
                    } else {
                        self.switchRoot(to: .home)
                    }
                }
            } else {
                switchRoot(to: .login)
            }
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
            let vcHome = Storyboard.getInstanceOf(HomeTabBarController.self)
            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeTabBarController") as! HomeTabBarController
            self.window?.rootViewController = homeVC
        case .login:
            let vcLogin = Storyboard.getInstanceOf(LoginViewController.self)
            self.window?.rootViewController = vcLogin
        }
    }
}

