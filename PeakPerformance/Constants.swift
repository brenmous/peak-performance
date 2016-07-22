//
//  Constants.swift
//  PeakPerformance
//
//  Created by Bren on 21/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation
import UIKit

/**
    This file contains various constants used throughout the program.
    If you find yourself using raw values (e.g. string literals) then consider if it should go here instead.
*/



// MARK: - Error messages
//N.B. Change these messages to something more appropriate/polite, just placeholders at the moment

//Required field error message.
let REQ_ERR_MSG = "This field is required."

//Alpha characters only error message.
let ALPHA_ERR_MSG = "No numbers or symbols allowed."

//Incorrect email error message.
let EMAIL_ERR_MSG = "Not a valid email address."

//Alphanumeric characters only error message.
let ALPNUM_ERR_MSG = "Only letters and numbers allowed."

//Password too short.
let SHORTPW_ERR_MSG = "Password must be a minimum of 6 characters."

//Password too long.
let LONGPW_ERR_MSG = "Password cannot be more than 32 characters."

//Bad password format.
let BADPW_ERR_MSG = "Password must contain at least one uppercase letter and one number."

//Password confirm field doesn't match.
let CONPW_ERR_MSG = "Passwords must match."


// MARK: - Password parameters
//Here's where we specify password min/max length and allowable characters.

//Password min length
let PW_MIN_LEN = 6

//Password max length
let PW_MAX_LEN = 32


// MARK: - Textfield parameters
//This is things like border width, color etc. of text fields

//The standard text field border size
let TF_REG_BRD = 0.5

//The text field border size for indicating an error
let TF_ERR_BRD = 1.0

//The standard text field border colour
let TF_REG_COL = UIColor.clearColor().CGColor

//The text field border colour for indicating an error
let TF_ERR_COL = UIColor.redColor().CGColor

