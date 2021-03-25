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
    
    #warning("Investigate how to put status bar in white instead of black")
    
    //MARK:- Variables
    let loguinPath: String = "https://platform.bluetrail.software/api/users/login"
    private var loginVM: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVM = LoginViewModel()
        
        #warning("Hey Cristian Look at me and analyze. Then Remove me")
        // Requesting endpoint DUMMY sample
        self.loginVM?.nameOfYourMethodWithArguments("Cristian", "yourPassword", { error in
           
            if let error = error  {
                print("Handle your error in UI here")
                print(error.localizedDescription)
            } else {
                print("Login successfull, Do something!")
            }
        })
    }
    
    @IBAction func loguinButton(_ sender: Any) {
        if let email = textEmail.text, let pass = textPassword.text {
            let credentials = Loguin(email: email, password: pass)
            AF.request(loguinPath,
                       method: .post,
                       parameters: credentials,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        
                        print(response)
                        
//                        let homeVC: HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                        // show home view controller
                       }
        } else {
            print("Empty")
        }
    }
}
