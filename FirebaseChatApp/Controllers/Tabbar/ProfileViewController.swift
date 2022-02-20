//
//  ProfileViewController.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    //MARK: - outlet
    @IBOutlet weak var profileTableView: UITableView!
    
    //MARK: - variables
    let data = ["Log Out"]
    
    //MARK: - lifecycle function
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }

}
//MARK: - extension for table view
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //alert
        let alert = UIAlertController(title: "Sign Out?", message: "You can always access your content by sign in back.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            //facebook logout
            FBSDKLoginKit.LoginManager().logOut()
            
            //google sign out
            GIDSignIn.sharedInstance().signOut()
            
            //firebase signout
            do {
                try Auth.auth().signOut()
                let loginVC = LoginViewController()
                let navVC = UINavigationController(rootViewController: loginVC)
                navVC.modalPresentationStyle = .fullScreen
                strongSelf.present(navVC, animated: true, completion: nil)
            }
            catch {
                print("failed to logout: \(error)")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
