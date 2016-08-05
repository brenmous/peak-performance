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

/// Required field error message.
let REQUIRED_FIELD_ERR_MSG = "This field is required."

/// Alpha characters only error message.
let ALPHA_CHAR_ERR_MSG = "No numbers or symbols allowed."

/// Incorrect email error message.
let BAD_EMAIL_ERR_MSG = "Not a valid email address."

/// Alphanumeric characters only error message.
let ALPHA_NUMERIC_CHAR_ERR_MSG = "Only letters and numbers allowed."

/// Password too short.
let SHORTPW_ERR_MSG = "Password must be a minimum of 6 characters."

/// Password too long.
let LONGPW_ERR_MSG = "Password cannot be more than 32 characters."

/// Bad password format.
let BADPW_ERR_MSG = "Password must contain at least one uppercase letter and one number."

/// Password confirm field doesn't match.
let CONPW_ERR_MSG = "Passwords must match."

/// Unable to log in due to user error (covers user not found, password mismatch, malformed email etc.).
let LOGIN_ERR_MSG = "No account found with provided details."

/// Too many requests made to server error message.
let REQUEST_ERR_MSG = "Too many login requests have been made. Please wait and try again."

/// Firebase network connection error.
let NETWORK_ERR_MSG = "Cannot connect to the network. Please wait and try again."

/// Email already in use sign up error.
let EMAIL_IN_USE_ERR_MSG = "An account already exists with this email address."


// MARK: - Password parameters
//Here's where we specify password min/max length and allowable characters.

/// Password min length
let PW_MIN_LEN = 6

/// Password max length
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

//Key Life Area strings.

/// The string for Family KLA.
let KLA_FAMILY = "Family"

/// String for Work/Business KLA.
let KLA_WORKBUSINESS = "Work/Business"

/// String for Personal Development KLA.
let KLA_PERSONALDEV = "Personal Development"

/// String for Financial KLA.
let KLA_FINANCIAL = "Financial"

/// String for Friends & Social KLA.
let KLA_FRIENDSSOCIAL = "Friends & Social"

/// String for Health & Fitness KLA.
let KLA_HEALTHFITNESS = "Health & Fitness"

/// String for Emotional/Spritiual KLA.
let KLA_EMOSPIRITUAL = "Emotional/Spritiual"

/// String for Partnert KLA.
let KLA_PARTNER = "Partner"


// MARK: - Database Reference Strings
//Strings used for creating database references.

/// Specifies users node in database.
let USERS_REF_STRING = "users"

/// Specifies user firstname node in database.
let FNAME_REF_STRING = "fname"

/// Specifies user lastname node in database.
let LNAME_REF_STRING = "lname"

/// Specifies user organistion node in database.
let ORG_REF_STRING = "org"

/// Specifies user email node in database.
let EMAIL_REF_STRING = "email"

/// Specifies weekly goals node in database.
let WEEKLYGOALS_REF_STRING = "weeklyGoals"

/// Specifies goal text node in database.
let GOALTEXT_REF_STRING = "goalText"

/// Specifies key life area node in database.
let KLA_REF_STRING = "kla"

/// Specifies deadline node in database.
let DEADLINE_REF_STRING = "deadline"

/// Specifies user ID node in database.
let UID_REF_STRING = "uid"

/// Specifies monthly goal node in database.
let MONTHLYGOALS_REF_STRING = "monthlyGoals"


// MARK: - Date Format Strings
let DATE_FORMAT_STRING = "dd/MM/yyyy"

// MARK: - Segue identifiers

/// Segue for when a user has logged in and all their details have been retrieved.
let LOGGED_IN_SEGUE = "loggedIn"

/// Segue for when a user logs in for the first time after signing up.
let FT_LOG_IN_SEGUE = "firstTimeLogIn"

/// Segue for when a user goes to the sign up view from the log in view.
let GO_TO_SIGN_UP_SEGUE = "goToSignUp"

/// Segue for when a user goes from the log in view to the sign up view.
let GO_TO_LOG_IN_SEGUE = "goToLogIn"

/// Segue for adding a new weekly goal.
let ADD_WEEKLY_GOAL_SEGUE = "addWeeklyGoal"

/// Segue for editing a weekly goal.
let EDIT_WEEKLY_GOAL_SEGUE = "editWeeklyGoal"