//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Canversation"
        view.backgroundColor = .red
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        //check is user logged in
        validateUser()
    }

    func validateUser() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
                let loginVC = LoginViewController()
                let navVC = UINavigationController(rootViewController: loginVC)
                navVC.modalPresentationStyle = .fullScreen
                present(navVC, animated: false, completion: nil)
        }
        else {
            print("user is present: \(FirebaseAuth.Auth.auth().currentUser)")
        }
    }
    
}

