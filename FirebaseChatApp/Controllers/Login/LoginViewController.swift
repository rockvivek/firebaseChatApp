//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import UIKit

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
    
    //MARK: - lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        //show a bar button item on right of navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        //adding subviews
        addSubviews()
        
        emailTF.delegate = self
        passwordTF.delegate = self
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
        
        
    }
    
    //MARK: - functions
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
        view.addSubview(scrollView)
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
    }
    
    @objc func didTapRegister() {
        print("register button tapped")
        let registerVC = RegisterViewController()
        registerVC.title = "Create Acocunt"
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}


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
