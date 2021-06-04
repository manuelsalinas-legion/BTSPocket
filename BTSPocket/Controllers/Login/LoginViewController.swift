//
//  LoginViewController.swift
//  BTSPocket
//
//  Created by bts on 24/03/21.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    // MARK: Outlets & Variables
    @IBOutlet weak private var textfieldEmail: UITextField!
    @IBOutlet weak private var textfieldPassword: UITextField!
    @IBOutlet weak private var buttonLogin: UIButton!
    @IBOutlet weak private var buttonFaceIdTouchId: UIButton!
    @IBOutlet weak private var labelVersion: UILabel! {
        didSet {
            self.labelVersion.text = Bundle.main.versionBuildNumber
        }
    }
    
    private var loginVM: LoginViewModel = LoginViewModel()
    private let localAuthenticationContext = LAContext()
    private var authorizationError: NSError?
    var expiredToken: Bool = false
    
    // MARK: LYFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        if expiredToken {
            MessageManager.shared.showBar(title: "Expired session", subtitle: "Your session has expired. Please, login again", type: .info, containsIcon: true, fromBottom: false)
        }
    }
    
    deinit {
        print("Deinit: \(String(describing: LoginViewController.self))")
    }
    
    // MARK: SETUP CONTROLLER
    private func setup() {
        // UI
        self.textfieldEmail.addBorder(edges: [.bottom], color: .grayConcrete(), thickness: 2)
        self.textfieldEmail.setLeftPaddingPoints(10)
        self.textfieldEmail.setRightPaddingPoints(10)
        self.textfieldPassword.addBorder(edges: [.bottom], color: .grayConcrete(), thickness: 2)
        self.textfieldPassword.setLeftPaddingPoints(10)
        self.textfieldPassword.setRightPaddingPoints(10)
        self.buttonLogin.round()
        self.loginButtonAvailability()
        
        // Biometrics
        if self.canUseLocalBiometricAutentication() {
            DispatchQueue.main.async {
                // Check credentials from keychain
                guard let _ = KeychainWrapper.standard.string(forKey: Constants.Keychain.kAuthUsername),
                      let _ = KeychainWrapper.standard.string(forKey: Constants.Keychain.kAuthPassword) else {
                    
                    self.buttonFaceIdTouchId.isHidden = true
                    return
                }
                self.buttonFaceIdTouchId.isHidden = false
                self.buttonFaceIdTouchId.setTitle(LAContext().biometryType == LABiometryType.faceID ? "Login with Face ID" : "Login with Touch ID", for: .normal)
            }
        } else {
            self.buttonFaceIdTouchId.isHidden = true
        }
    }
    
    // MARK: ACTIONS
    @IBAction private func authenticate() {
        // Dismiss keyboard
        self.view.endEditing(true)
        
        // Validations
        guard let email = self.textfieldEmail.text?.trim(), !email.isEmpty, email.isEmail() else {
            MessageManager.shared.showBar(title: "Warning", subtitle: "Invalid email", type: .warning, containsIcon: true, fromBottom: false)
            return
        }
        
        guard let pass = self.textfieldPassword.text?.trim(), !pass.isEmpty else {
            MessageManager.shared.showBar(title: "Warning", subtitle: "Empty password", type: .warning, containsIcon: true, fromBottom: false)
            return
        }

        // Indicator
        self.buttonLogin.isEnabled = false
        MessageManager.shared.showLoadingHUD()
        
        // Authenticating...
        self.loginVM.login(email, pass) { [weak self] error in
            
            // Indicator
            self?.buttonLogin.isEnabled = true
            MessageManager.shared.hideHUD()
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    MessageManager.shared.showBar(title: "Error", subtitle: "Invalid credentials", type: .error, containsIcon: true, fromBottom: false)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    // preguntar si guardar credenciales en keychain
                    if self?.canUseLocalBiometricAutentication() == true {
                        // si hay credenciales en el key chain
                        if KeychainWrapper.standard.string(forKey: Constants.Keychain.kAuthUsername) == nil && KeychainWrapper.standard.string(forKey: Constants.Keychain.kAuthPassword) == nil {
                            // show alert
                            let alert = UIAlertController(title: "Relate credentials", message: "Relate credentials with biometric autentication", preferredStyle: .alert)
                            // action no
                            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                                self?.showHome()
                            }))
                            // action yes
                            alert.addAction(UIAlertAction(title: "Agree", style: .default, handler: { (_) in
                                // autenticate with LA
                                self?.localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Reason") { (success, error) in
                                    if success {
                                        // save credentials in keychan reted with faceId
                                        KeychainWrapper.standard.set(email, forKey: Constants.Keychain.kAuthUsername)
                                        KeychainWrapper.standard.set(pass, forKey: Constants.Keychain.kAuthPassword)
                                    }
                                    self?.showHome()
                                }
                            }))
                            self?.present(alert, animated: true, completion: nil)
                        } else {
                            self?.showHome()
                        }
                    } else {
                        self?.showHome()
                    }
                }
            }
        }
    }
    
    @IBAction private func showBiometrics() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"

        var authorizationError: NSError?
        let reason = "Authentication required to access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                
                if success {
                    guard let username = KeychainWrapper.standard.string(forKey: Constants.Keychain.kAuthUsername),
                          let password = KeychainWrapper.standard.string(forKey: Constants.Keychain.kAuthPassword) else {
                        
                        print("error: credentials weren't able to recover from keychain")
                        return
                    }
                    
                    // Fill Textfields
                    DispatchQueue.main.async {
                        self.textfieldEmail.text = username
                        self.textfieldPassword.text = password
                    }
                    
                    // Request login
                    self.loginVM.login(username, password, { [weak self] error in
                        if let error = error {
                            // Show message
                            MessageManager.shared.showBar(title: "Error", subtitle: error.localizedDescription, type: .error, containsIcon: true, fromBottom: false)
                            
                            // Clean Textfields
                            DispatchQueue.main.async {
                                self?.textfieldPassword.text = String()
                            }
                        } else {
                            self?.showHome()
                        }
                    })
                    
                } else {
                    // Failed to authenticate
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(error)
                    
                    // Clean Textfields
                    DispatchQueue.main.async {
                        self.textfieldPassword.text = String()
                    }
                }
            }
        } else {
            
            guard let error = authorizationError else {
                return
            }
            print(error)
        }
    }
    
    // MARK: HELPERS
    private func canUseLocalBiometricAutentication() -> Bool {
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            print("can use local auth")
            return true
        }
        else {
            print("cannot use local auth")
            return false
        }
    }
    
    private func loginButtonAvailability() {
        self.buttonLogin.isEnabled = self.textfieldEmail.text?.trim().isEmpty == false && self.textfieldPassword.text?.trim().isEmpty == false
    }
    
    // MARK: GO HOME
    private func showHome() {
        DispatchQueue.main.async {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.switchRoot(to: .home)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.loginButtonAvailability()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.loginButtonAvailability()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.loginButtonAvailability()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textfieldEmail {
            textField.resignFirstResponder()
            self.textfieldPassword.becomeFirstResponder()
        } else if textField == self.textfieldPassword {
            textField.resignFirstResponder()
            self.authenticate()
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
