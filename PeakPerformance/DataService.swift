//
//  DataService.swift
//  FirebaseTest
//
//  Created by Bren on 18/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation
import Firebase

class DataService: SignUpDataService, LogInDataService
{
    let baseRef = FIRDatabase.database().reference()

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