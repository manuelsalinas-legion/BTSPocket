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
    @IBOutlet weak private var textEmail: UITextField!
    @IBOutlet weak private var textPassword: UITextField!
    
    //MARK:- Variables
    private var loginVM: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVM = LoginViewModel()
        
    }
    
    @IBAction private func loginButton(_ sender: Any) {
        
        if let email = textEmail.text?.trim(), let pass = textPassword.text?.trim(), email.isEmail(), !email.isEmpty, !pass.isEmpty {
            print(email)
            self.loginVM?.login(email, pass, { error in
                if let error = error {
                    print(error)
                    showAlert(view: self, title: "Server Error", message: "Bad credentials")
                } else {
                    let sceneDelegateVariable = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegateVariable?.switchRoot(to: .home)
                }
            })
        } else {
            showAlert(view: self, title: "Error", message: "Invalid credentials")
        }
    }
}
