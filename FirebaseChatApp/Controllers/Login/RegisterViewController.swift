//
//  RegisterViewController.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - variables
    private var scrollView:UIScrollView {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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
    
    private let firstnameTF: UITextField = {
        let textField = UITextField()
        textField.setupTextField(cornerRadius: textFieldValue.cornerRadius,
                                 borderWidth: textFieldValue.borderWidth,
                                 borderColor: textFieldValue.borderColor,
                                 returnType: .done)
        textField.setPlaceHolder(placeholderSting: "Enter Firstname")
        textField.withImage(direction: .Left,
                            image: UIImage(named: "profile")!,
                            colorSeparator: .clear)
        return textField
    }()
    
    private let lastnameTF: UITextField = {
        let textField = UITextField()
        textField.setupTextField(cornerRadius: textFieldValue.cornerRadius,
                                 borderWidth: textFieldValue.borderWidth,
                                 borderColor: textFieldValue.borderColor)
        textField.setPlaceHolder(placeholderSting: "Enter Lastname")
        textField.withImage(direction: .Left,
                            image: UIImage(named: "profile")!,
                            colorSeparator: .clear)
        return textField
    }()
    
    private let registerButton:UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 23)
        button.layer.cornerRadius = buttonValue.cornerRadius
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .white
        
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
        
        imageView.layer.cornerRadius = imageView.width / 2.0
        
        firstnameTF.frame = CGRect(x: 25,
                                   y: imageView.bottom + 40,
                                   width: view.width - 50,
                                   height: 50)
        
        lastnameTF.frame = CGRect(x: 25,
                                  y: firstnameTF.bottom + 20,
                                  width: view.width - 50,
                                  height: 50)
        
        emailTF.frame = CGRect(x: 25,
                               y: lastnameTF.bottom + 20,
                               width: view.width - 50,
                               height: 50)
        
        passwordTF.frame = CGRect(x: 25,
                                  y: emailTF.bottom + 20,
                                  width: view.width - 50,
                                  height: 50)
        
        registerButton.frame = CGRect(x: 25,
                                      y: passwordTF.bottom + 40,
                                      width: view.width - 50,
                                      height: 50)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfielPic))
        imageView.addGestureRecognizer(gesture)
    }
    
    //MARK: - functions
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(firstnameTF)
        view.addSubview(lastnameTF)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(registerButton)
        view.addSubview(scrollView)
    }
    
    //MARK: - Actions
    @objc func didTapChangeProfielPic() {
        print("change profile pic called")
        presentPhotoActionSheet()
    }
    
    @objc func registerButtonTapped() {
        
        //validation
        guard let email = emailTF.text, !email.isBlank, email.isEmail else  {
            let alert = alertBoxWithOneButton(message: "Email is not valid. Please enter valid email.")
            present(alert, animated: true, completion: nil)
            return
        }
        guard let password = passwordTF.text, !password.isBlank, password.count > 8, password.isValidPassword else  {
            let alert = alertBoxWithOneButton(message: "Password must contains 8 digit. atleast one small case, capital case digit and special character.")
            present(alert, animated: true, completion: nil)
            return
        }
        guard let firstname = firstnameTF.text, !firstname.isBlank else  {
            let alert = alertBoxWithOneButton(message: "first name can't be blank")
            present(alert, animated: true, completion: nil)
            return
        }
        guard let lastname = lastnameTF.text, !lastname.isBlank else  {
            let alert = alertBoxWithOneButton(message: "last name can't be blank")
            present(alert, animated: true, completion: nil)
            return
        }
        //signup steps
        //save user data to database
        DatabaseManager.shared.userExist(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                //user already exist
                alertBoxWithOneButton(message: "Looks like a user account for this email id acocunt is already exist.")
                return
            }
            AuthManager.shared.createUser(email: email, password: password) { isUserCreated in
                if isUserCreated {
                    print("new user craeted successfully")
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstname, lastName: lastname, emailID: email))
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
}


//login controller for text field delegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameTF {
            lastnameTF.becomeFirstResponder()
        }
        else if textField == lastnameTF {
            emailTF.becomeFirstResponder()
        }
        else if textField == emailTF {
            passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF {
            registerButtonTapped()
        }
        return true
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture.", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] else { return }
        self.imageView.image = selectedImage as! UIImage
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
