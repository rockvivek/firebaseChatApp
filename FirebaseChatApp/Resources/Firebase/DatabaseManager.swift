//
//  DatabaseManager.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 18/02/22.
//

import Foundation
import FirebaseDatabase
import UIKit

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailID: String
    var safeEmail: String {
        var safeEmail = emailID.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
//    let photoURl: String
}

final class DatabaseManager {
    
    //MARK: - singolton class
    static let shared = DatabaseManager()
    
    //database reference
    private let database = Database.database().reference()
}

//MARK: - Account management
extension DatabaseManager{
    
    public func userExist(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard ((snapshot.value as? String) != nil) else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    ///insert data for new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}
