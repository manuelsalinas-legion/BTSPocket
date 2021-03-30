//
//  LoginViewController.swift
//  BTSPocket
//
//  Created by bts on 24/03/21.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    //MARK:- Variables
    private var loginVM: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVM = LoginViewModel()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let email = textEmail.text, let pass = textPassword.text {
            self.loginVM?.login(email, pass, { error in
                if let error = error {
                    print(error)
                } else {
                    let sceneDelegateVariable = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegateVariable?.switchRoot(to: .home)
                }
            })
        } else {
            print("Invalid fields")
        }
    }
}
