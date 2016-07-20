//
//  User.swift
//  PeakPerformance
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation

/**
    Class that represents a peak performance user
 */
class User
{
    /// User's first name.
    var fname: String
    
    /// User's last name.
    var lname: String
    
    /// User's organisation.
    var org: String
    
    /// User's email.
    var email: String
    
    /// User's username.
    var username: String
    
    /// User's unique ID.
    var uid: String
    
    /**
        Initialises a new user.

        - Parameters:
            - fname: user's first name.
            - lname: user's last name.
            - org: user's organisation.
            - email: user's email.
            - username: user's username.
            - uid: user's unique ID.
    */
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