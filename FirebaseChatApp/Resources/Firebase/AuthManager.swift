//
//  FirebaseAuth.swift
//  ChatApplication
//
//  Created by vivek shrivastwa on 13/02/22.
//

import Foundation
import FirebaseAuth
import UIKit


class AuthManager {
    //MARK: - shared variable
    static let shared = AuthManager()
    
    //MARK: - craeteNewUSer
    public func createUser(email:String, password:String, completion: @escaping ((Bool) -> Void)){
        //sign up to firebase
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project.
                    print("Error: The given sign-in provider is disabled for this Firebase project")
                    break
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    print("Error: The email address is already in use by another account.")
                    break
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    print("Error: The email address is badly formatted.")
                    break
                case .weakPassword:
                    // Error: The password must be 6 characters long or more.
                    print(" Error: The password must be 6 characters long or more.")
                    break
                default:
                    print("Error: \(error.localizedDescription)")
                }
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    //MARK: - loginUser
    public func loginUser(email:String, password:String, completion: @escaping ((Bool) -> Void)){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    print("Error: Indicates that email and password accounts are not enabled")
                    completion(false)
                    break
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    print("Error: The user account has been disabled by an administrator.")
                    completion(false)
                    break
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    print("Error: The password is invalid or the user does not have a password.")
                    completion(false)
                    break
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    print("Error: Indicates the email address is malformed.")
                    completion(false)
                    break
                default:
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                completion(true)
            }
        }
    }
    
    
    //MARK: - forgotPassword
    func forgotPassword(emailid:String, completion: @escaping ((Bool) -> Void)) {
        
        Auth.auth().sendPasswordReset(withEmail: emailid, completion: { (error) in
            if error != nil{
                print("error occured: \(error)")
                completion(false)
            }else {
               completion(true)
                print("password reset successfull")
            }
        })
    }
}
