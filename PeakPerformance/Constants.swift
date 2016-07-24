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
let REQUIRED_FIELD_ERR_MSG = "This field is required."

//Alpha characters only error message.
let ALPHA_CHAR_ERR_MSG = "No numbers or symbols allowed."

//Incorrect email error message.
let BAD_EMAIL_ERR_MSG = "Not a valid email address."

//Alphanumeric characters only error message.
let ALPHA_NUMERIC_CHAR_ERR_MSG = "Only letters and numbers allowed."

//Password too short.
let SHORTPW_ERR_MSG = "Password must be a minimum of 6 characters."

//Password too long.
let LONGPW_ERR_MSG = "Password cannot be more than 32 characters."

//Bad password format.
let BADPW_ERR_MSG = "Password must contain at least one uppercase letter and one number."

//Password confirm field doesn't match.
let CONPW_ERR_MSG = "Passwords must match."

//Unable to log in due to user error (covers user not found, password mismatch, malformed email etc.).
let LOGIN_ERR_MSG = "No account found with provided details."

//Too many requests made to server error message.
let REQUEST_ERR_MSG = "Too many login requests have been made. Please wait and try again."

//Firebase network connection error.
let NETWORK_ERR_MSG = "Cannot connect to the network. Please wait and try again."

//Email already in use sign up error.
let EMAIL_IN_USE_ERR_MSG = "An account already exists with this email address."


// MARK: - Password parameters
//Here's where we specify password min/max length and allowable characters.

//Password min length
let PW_MIN_LEN = 6

//Password max length
let PW_MAX_LEN = 32


// MARK: - Textfield parameters
//This is things like border width, color etc. of text fields

//The standard text field border size
let TEXTFIELD_REGULAR_BORDER_WIDTH = 0.5

//The text field border size for indicating an error
let TEXTFIELD_ERROR_BORDER_WIDTH = 1.0

//The standard text field border colour
let TEXTFIELD_REGULAR_BORDER_COLOUR = UIColor.clearColor().CGColor

//The text field border colour for indicating an error
let TEXTFIELD_ERROR_BORDER_COLOUR = UIColor.purpleColor().CGColor
// UIColor:(160.0, 97.0, 5.0, 1.0)
// UIColor(red: (160/255.0), green: (97/255.0), blue: (5/255.0), alpha: 1.0)


// MARK: - Key Life Areas

//An enum for the key life areas. TODO: Add rest of KLAs.
enum KeyLifeArea: String
{
    case Family = "Family"
    
    case Work = "Work & Business"
    
    case Emotional = "Emotional & Spritual"
    
    case Parter = "Partner"
}
