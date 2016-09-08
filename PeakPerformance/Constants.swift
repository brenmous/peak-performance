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
let BADPW_ERR_MSG = "Must contain an uppercase letter & number."

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

/// Firebase internal error.
let FIR_INTERNAL_ERROR = "An error occurred with Firebase. Please report to <EMAIL>"

/// User account disabled error.
let USER_DISABLED_ERROR = "This account has been disabled."

/// Wrong password error.
let WRONG_PW_ERROR = "Email and password do not match."

/// Reset password email successfully sent.
let RESET_EMAIL_SENT = "A reset password email has been sent to this account."


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
let TEXTFIELD_ERROR_BORDER_COLOUR = UIColor.init(red: 199/255, green: 204/255, blue: 31/255, alpha: 1).CGColor



// MARK: - Key Life Areas

//Key Life Area strings.

/// The string for Family KLA.
let KLA_FAMILY = "Family"

/// String for Work/Business KLA.
let KLA_WORKBUSINESS = "Work & Business" // Firebase reads this as slash so it creates 2 nodes for work AND business - Ben

/// String for Personal Development KLA.
let KLA_PERSONALDEV = "Personal Development"

/// String for Financial KLA.
let KLA_FINANCIAL = "Financial"

/// String for Friends & Social KLA.
let KLA_FRIENDSSOCIAL = "Friends & Social"

/// String for Health & Fitness KLA.
let KLA_HEALTHFITNESS = "Health & Fitness"

/// String for Emotional/Spritiual KLA.
let KLA_EMOSPIRITUAL = "Emotional & Spiritual"

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

/// Specifies user start date node in database.
let STARTDATE_REF_STRING = "startDate"

/// Specifies weekly goals node in database.
let WEEKLYGOALS_REF_STRING = "weeklyGoals"

/// Specifies goal text node in database.
let GOALTEXT_REF_STRING = "goalText"

/// Specifies key life area node in database.
let KLA_REF_STRING = "kla"

/// Specifies My Values node in database.
let VALUES_REF_STRING = "values"

/// Specifies kick text node in database.
let KICKIT_REF_STRING = "kickItText"

/// Specifies complete node in database.
let COMPLETE_REF_STRING = "complete"

/// Specifies summarised node in database.
let SUMMARISED_REF_STRING = "summarised"

/// Specifies deadline node in database.
let DEADLINE_REF_STRING = "deadline"

/// Specifies user ID node in database.
let UID_REF_STRING = "uid"

/// Specifies monthly goal node in database.
let MONTHLYGOALS_REF_STRING = "monthlyGoals"

/// Specifies dreams node in database.
let DREAMS_REF_STRING = "dreams"

/// Specifies dream description node in database.
let DREAMTEXT_REF_STRING = "text"

/// Specifies dream local URL node in database.
let DREAMLOCALURL_REF_STRING = "localURL"

/// Specifies dream URL node in database.
let DREAMURL_REF_STRING = "url"

//summary ref strings
/// Specifies summary date in database.
let SUMMARY_DATE_REF_STRING = "date"

/// Specifies summary weekly goals in database.
let SUMMARY_WG_REF_STRING = "weeklyGoals"

/// Specifies summary monthly goals in database.
let SUMMARY_MG_REF_STRING = "monthlyGoals"

// MARK: - Firebase storage reference strings

/// Base URL for storage bucket.
let STORAGE_REF_BASE = "gs://peakperformance-d37a7.appspot.com"


// MARK: - Date Format Strings
let DAY_MONTH_YEAR_FORMAT_STRING = "dd/MM/yyyy"

let MONTH_FORMAT_STRING = "MMMM"

let MONTH_YEAR_FORMAT_STRING = "MMMM yyyy"

let MONTH_DAY_FORMAT_STRING = "MMMM dd"

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

/// Segue for adding a new monthly goal.
let ADD_MONTHLY_GOAL_SEGUE = "addMonthlyGoal"

/// Segue for editing a monthly goal.
let EDIT_MONTHLY_GOAL_SEGUE = "editMonthlyGoal"

/// Segue for going to tutorial from sign up.
let GO_TO_TUTORIAL_SEGUE = "goToTutorial"

/// Segue for unwinding from WG detail view.
let UNWIND_FROM_WGDVC_SEGUE = "unwindFromWGDVC"

/// Segue for unwinding to login,
let UNWIND_TO_LOGIN = "unwindFromWGVC"

/// Segue for unwinding from MG detail view.
let UNWIND_FROM_MGDVC_SEGUE = "unwindFromMGDVC"

/// Segue for unwinding from Dream detail view.
let UNWIND_FROM_DDVC_SEGUE = "unwindFromDDVC"

/// Segue for going to reset password from log in.
let GO_TO_RESET_PW_SEGUE = "goToResetPassword"

/// Segue for skipping tutorial
let GO_TO_TAB_BAR = "skipTutorial"


let GO_TO_LOG_IN = "logOut"

/// Segue for adding a new dream.
let ADD_DREAM_SEGUE = "addDream"

/// Segue for editing a dream.
let EDIT_DREAM_SEGUE = "editDream"

/// Segue for going from history view to review view
let GO_TO_REVIEW_SEGUE = "goToMonthlyReview"

/// Segue for going from first MR view to second MR view
let GO_TO_SECOND_REVIEW_SEGUE = "goToMonthlyReviewSecond"


// MARK: - Alert sheet strings

/// Title for goal completion alert sheet
let COMPLETION_ALERT_TITLE = "Congratulations!"

/// Message for goal completion alert sheet
let COMPLETION_ALERT_MSG = "How would you take this task to the next level?"

/// Title for completion alert confirm action
let COMPLETION_ALERT_CONFIRM = "Kick it!"

/// Title for completion alert cancel action
let COMPLETION_ALERT_CANCEL = "Cancel"

/// Placeholder for kick it text field
let KICKIT_PLACEHOLDER_STRING = "I will..."

/// Sign Out alert title
let SIGNOUT_ALERT_TITLE = "Sign Out"

/// Sign out alert msg
let SIGNOUT_ALERT_MSG = "Do you want to sign out?"

/// Sign out confirm
let SIGNOUT_ALERT_CONFIRM = "Sign out"

/// Sign out alert cancel
let SIGNOUT_ALERT_CANCEL = "Cancel"

/// Delete dream title
let DELETE_DREAM_ALERT_TITLE = "Delete Dream"

/// Message for deleting dream
let DELETE_DREAM_ALERT_MSG = "Are you sure you want to delete this dream?"

/// Delete the dream
let DELETE_DREAM_ALERT = "Delete"

/// Cancel dream deletion
let CANCEL_DREAM_ALERT = "Cancel"

/// My Values Saved
let SAVED_VALUES = "Values saved."

/// Confirm saved values alert
let CONFIRM_SAVE_VALUES =  "Confirm"

/// Review alert title
let REVIEW_ALERT_TITLE = "Monthly Review Ready"

/// Review alert message
let REVIEW_ALERT_MSG = "You have a monthly review to complete. Would you like to do it now?"

/// Review alert cancel
let REVIEW_ALERT_CANCEL = "No thanks, later."

/// Review alert confirm
let REVIEW_ALERT_CONFIRM = "Sure."

// MARK: - Storyboard IDs

/// Identifier for Sign Out side menu cell
let SIGNOUT_CELL_ID = "signOut"

/// Storyboard identfier for Side Menu View Controller
let SIDE_MENU_VC = "SideMenu"

/// Identifier for Monthly Review side menu cell.
let MONTHLYREVIEW_CELL_ID = "monthlyReview"

/// Identifier for Monthly Review view controller.
let MONTHLYREVIEW_VC = "MonthlyReview"

// MARK: - Image quality constant

/// Constant for compression of JPEG UIImage representation.
let JPEG_QUALITY: CGFloat = 0.25



