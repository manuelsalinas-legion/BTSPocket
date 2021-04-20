//
//  LoginViewController.swift
//  BTSPocket
//
//  Created by bts on 24/03/21.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak private var textEmail: UITextField!
    @IBOutlet weak private var textPassword: UITextField!
    @IBOutlet weak var buttonFaceIdTouchId: UIButton!
    
    //MARK:- Variables
    private var loginVM: LoginViewModel?
    private let localAuthenticationContext = LAContext()
    private var authorizationError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVM = LoginViewModel()
        self.textEmail.delegate = self
        self.textEmail.returnKeyType = .next
        self.textEmail.keyboardType = .emailAddress
        self.textPassword.delegate = self
        self.textPassword.returnKeyType = .done
        
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"
        
        let emailExist = KeychainWrapper.standard.string(forKey: "authEmail")
        let passwordExist = KeychainWrapper.standard.string(forKey: "authPassword")
        
        if canUseLocalBiometricAutentication() {
            if emailExist == nil && passwordExist == nil {
                self.buttonFaceIdTouchId.isHidden = true
            }
        } else {
            self.buttonFaceIdTouchId.isHidden = true
        }
        
    }
    
    @IBAction private func loginButton(_ sender: Any) {
        if let email = textEmail.text?.trim(), let pass = textPassword.text?.trim(), email.isEmail(), !email.isEmpty, !pass.isEmpty {
            self.loginVM?.login(email, pass, { error in
                if let error = error {
                    print(error)
                    showAlert(view: self, title: "Server Error", message: "Bad credentials")
                } else {
                    // preguntar si guardar credenciales en keychain
                    if self.canUseLocalBiometricAutentication() {
                        // si hay credenciales en el key chain
                        if KeychainWrapper.standard.string(forKey: "authEmail") == nil && KeychainWrapper.standard.string(forKey: "authPassword") == nil {
                            // show alert
                            let alert = UIAlertController(title: "Relate credentials", message: "Relate credentials with biometric autentication", preferredStyle: .alert)
                            // action no
                            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
                                self.showHome()
                            }))
                            // action yes
                            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                                // autenticate with LA
                                self.localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Reason") { (success, error) in
                                    if success {
                                        // save credentials in keychan reted with faceId
                                        KeychainWrapper.standard.set(email, forKey: "authEmail")
                                        KeychainWrapper.standard.set(pass, forKey: "authPassword")
                                    }
                                    self.showHome()
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            self.showHome()
                        }
                    } else {
                        self.showHome()
                    }
                }
            })
        } else {
            showAlert(view: self, title: "Error", message: "Invalid credentials")
        }
    }
    
    func showHome() {
        DispatchQueue.main.async {
            let sceneDelegateVariable = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegateVariable?.switchRoot(to: .home)
        }
    }
    
    // check if it have a local autentication
    func canUseLocalBiometricAutentication() -> Bool {
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            print("can use local auth")
            return true
        }
        else {
            print("cannot use local auth")
            return false
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textEmail {
            textField.resignFirstResponder()
            self.textPassword.becomeFirstResponder()
        } else if textField == textPassword {
            textField.resignFirstResponder()
            self.loginButton((Any).self)
        }
        return false
    }
}

// MARK: - TAP GESTURE (Dismiss Keyboard)
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
