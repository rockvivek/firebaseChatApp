//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    //MARK: - variables
    private var scrollView:UIScrollView {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let passwordTF: UITextField = {
        let textField = UITextField()
        textField.setupTextField(cornerRadius: textFieldValue.cornerRadius,
                                 borderWidth: textFieldValue.borderWidth,
                                 borderColor: textFieldValue.borderColor,
                                 returnType: .done)
        textField.setPlaceHolder(placeholderSting: "Enter Password")
        textField.withImage(direction: .Left,
                            image: UIImage(named: "password")!,
                            colorSeparator: .clear)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let fbLoginButton = FBLoginButton()
    
    let googleLoginButton = GIDSignInButton()
    
    private let emailTF: UITextField = {
        let textField = UITextField()
        textField.setupTextField(cornerRadius: textFieldValue.cornerRadius,
                                 borderWidth: textFieldValue.borderWidth,
                                 borderColor: textFieldValue.borderColor)
        textField.setPlaceHolder(placeholderSting: "Enter Email")
        textField.withImage(direction: .Left,
                            image: UIImage(named: "email")!,
                            colorSeparator: .clear)
        return textField
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 23)
        button.layer.cornerRadius = buttonValue.cornerRadius
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var loginObserver: NSObjectProtocol?
    
    //MARK: - lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        //add observer
        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name.didLogInNotification,
                                                               object: nil,
                                                               queue: .main,
                                                               using: { [weak self]_ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        //show a bar button item on right of navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        //adding subviews
        addSubviews()
        
        fbLoginButton.permissions = ["public_profile", "email"]
        fbLoginButton.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(loginObserver)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //frame
        
        scrollView.frame = view.bounds
        
        let size = view.width / 3
        imageView.frame = CGRect(x: (view.width - size) / 2,
                                 y: 150,
                                 width: size,
                                 height: size)
        
        emailTF.frame = CGRect(x: 25,
                               y: imageView.bottom + 70,
                               width: view.width - 50,
                               height: 50)
        
        passwordTF.frame = CGRect(x: 25,
                                  y: emailTF.bottom + 20,
                                  width: view.width - 50,
                                  height: 50)
        
        loginButton.frame = CGRect(x: 25,
                                   y: passwordTF.bottom + 40,
                                   width: view.width - 50,
                                   height: 50)
        
        fbLoginButton.frame = CGRect(x: loginButton.left + 30,
                                     y: loginButton.bottom + 70,
                                     width: loginButton.width - 60,
                                     height: loginButton.height - 10)
        fbLoginButton.layer.cornerRadius = 12
        
        googleLoginButton.frame = CGRect(x: loginButton.left + 30,
                                         y: fbLoginButton.bottom + 20,
                                         width: loginButton.width - 60,
                                         height: loginButton.height - 10)
        
    }
    
    //MARK: - functions
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
        view.addSubview(scrollView)
        view.addSubview(fbLoginButton)
        view.addSubview(loginButton)
        view.addSubview(googleLoginButton)
    }
    
    //MARK: - Actions
    @objc func loginButtonTapped() {
        
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        //validation
        guard let email = emailTF.text, !email.isBlank else  {
            let alert = alertBoxWithOneButton(message: "Email is not valid. Please enter valid email.")
            present(alert, animated: true, completion: nil)
            return
        }
        guard let password = passwordTF.text, !password.isBlank, password.count > 8 else  {
            let alert = alertBoxWithOneButton(message: "Password must contains 8 digit. atleast one small case, capital case digit and special character.")
            present(alert, animated: true, completion: nil)
            return
        }
        //login steps
        AuthManager.shared.loginUser(email: email, password: password) { isLogin in
            if isLogin {
                print("user login successfull")
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapRegister() {
        print("register button tapped")
        let registerVC = RegisterViewController()
        registerVC.title = "Create Acocunt"
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

//MARK: - LoginViewExt for textField
//login controller for text field delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF {
            loginButtonTapped()
        }
        return true
    }
}

//MARK: - LoginViewExt for facebook login delgate
extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to login with facebook")
            return
        }
        
        //generate facebook request
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start { _, result, error in
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make facebook graph request.")
                return
            }
            
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                      print("failed to get name and email from facebook request")
                      return
                  }
            //divide the full ame into first and last name
            let nameComponent = userName.components(separatedBy: " ")
            guard nameComponent.count == 2 else { return }
            let firstName = nameComponent[0]
            let lastName = nameComponent[1]
            
            DatabaseManager.shared.userExist(with: "email") { isExist in
                if !isExist {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailID: email))
                }
            }
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            guard let result = authResult, error == nil else {
                print("facebook credential login failed \(error)")
                return
            }
            print("successfully login to faceboook")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
}


extension LoginViewController {
    
}
