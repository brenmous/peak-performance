//
//  User.swift
//  FirebaseTest
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation


class User
{
    var fname: String
    var lname: String
    var org: String
    var email: String
    var username: String
    var uid: String
    
    init( fname: String, lname: String, org: String, email: String, username: String, uid: String )
    {
        self.fname = fname
        self.lname = lname
        self.org = org
        self.email = email
        self.username = username
        self.uid = uid
    }
}