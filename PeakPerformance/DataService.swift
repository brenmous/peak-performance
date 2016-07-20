//
//  DataService.swift
//  PeakPerformance
//
//  Created by Bren on 18/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation
import Firebase

/**
    This class handles read/write to the Firebase realtime database.
  */
class DataService: SignUpDataService, LogInDataService
{
    // MARK: - Properties
    
    /// Base reference to the Firebase DB.
    let baseRef = FIRDatabase.database().reference()

    
    // MARK: - Methods
    
    /**
        Saves a user's details to the database.

        - Parameters:
            - user: the user being saved.
    */
    func saveUser(user: User) {
        
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(user.uid)
        userRef.child("fname").setValue(user.fname)
        userRef.child("lname").setValue(user.lname)
        userRef.child("org").setValue(user.org)
        userRef.child("username").setValue(user.username)
        userRef.child("email").setValue(user.email)
        print("user stored in database")
        
    }
    
    /**
        Loads a user from the database and creates a user object.

        - Parameters:
            - uid: the user's unique ID.

        - Returns: the user object.
    */
    func loadUser( uid: String ) -> User {
        
        let usersRef = baseRef.child("users")
        let userRef = usersRef.child(uid)
        var fname = ""
        var lname = ""
        var org = ""
        var username = ""
        var email = ""
        
        userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            fname = snapshot.value!["fname"] as! String
            lname = snapshot.value!["lname"] as! String
            org = snapshot.value!["org"] as! String
            username = snapshot.value!["username"] as! String
            email = snapshot.value!["email"] as! String
        })
        
        print("user details fetched from database")
        return User(fname: fname, lname: lname, org: org, email: email, username: username, uid: uid)
        
    }
    
}