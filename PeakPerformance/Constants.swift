//
//  Constants.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 21/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation
import UIKit

/**
    This file contains various constants used throughout the program.
    If you find yourself using raw values (e.g. string literals) then consider if it should go here instead.
*/

/// VERSION NUMBER
let VERSION_NUMBER = "1.0"

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

/// Change password - wrong current password.
let CHANGE_PW_ERROR = "Incorrect password. Please re-enter your current password."

/// User.checkYearlyReview fatal error message - system time earlier than app expectation.
let USER_YEARLY_REVIEW_FATAL_ERR_MSG = "User.checkYearlyReview(): system time has been set earlier than what the app expects. Please change system time back to current date"


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
let TEXTFIELD_ERROR_BORDER_COLOUR = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor



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

/// Specifies users year in database.
let USER_YEAR_REF_STRING = "year"

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

/// Specifies main summaries node in database.
let SUMMARIES_REF_STRING = "summaries"

/// Specifies summary date in database.
let SUMMARY_DATE_REF_STRING = "date"

/// Specifies summary weekly goals in database.
let SUMMARY_WG_REF_STRING = "weeklyGoals"

/// Specifies summary monthly goals in database.
let SUMMARY_MG_REF_STRING = "monthlyGoals"

/// Specifies summary KLA ratings in databse.
let SUMMARY_RATINGS_REF_STRING = "ratings"

/// Specifies summary "whatIsWorking" text in database.
let SUMMARY_WIW_REF_STRING = "working"

/// Specifies summary "whatIsNotWorking" text in database.
let SUMMARY_WINOTW_REF_STRING = "notWorking"

/// Specifies summary "whatHaveIImproved" text in database.
let SUMMARY_WHII_REF_STRING = "improved"

/// Specifies summary "doIhaveToChange..." text in database. 
let SUMMARY_DIHTC_REF_STRING = "needToChange"

/// Specifies summary reviewed boolean in database.
let SUMMARY_REVIEWED_REF_STRING = "reviewed"

/// Specifies summary sent boolean in database.
let SUMMARY_SENT_REF_STRING = "sent"

/// Specifies current reality summary in database.
let CURRENT_REALITY_SUMMARY_REF_STRING = "initial"

/// Specifies user's coach email node.
let COACH_EMAIL_REF_STRING = "coachEmail"

/// Specifies yearly summary node.
let YEARLY_REVIEW_REF_STRING = "yearly"


/// Specifies yearly summary "differences to plan" node.
let YEARLY_REVIEW_DIFF_REF_STRING = "differences"

/// Specifies yearly summary "observed about performance" node.
let YEARLY_REVIEW_OBS_REF_STRING = "observations"

/// Specifies yearly summary "changes to performance" node.
let YEARLY_REVIEW_CHA_REF_STRING = "changes"



// MARK: - Firebase storage reference strings

/// Base URL for storage bucket.
let STORAGE_REF_BASE = "gs://peakperformance-d37a7.appspot.com"


// MARK: - Date Format Strings
let DAY_MONTH_YEAR_FORMAT_STRING = "dd/MM/yyyy"

let MONTH_FORMAT_STRING = "MMMM"

let MONTH_YEAR_FORMAT_STRING = "MMMM yyyy"

let MONTH_DAY_FORMAT_STRING = "MMMM dd"

// MARK: - Segue identifiers

//TODO: - rename segues (SVC_TO_DVC_SEGUE and UNWIND_TO_DVC_SEGUE)

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
let UNWIND_TO_LOGIN = "unwindToLogin"

/// Segue for unwinding from MG detail view.
let UNWIND_FROM_MGDVC_SEGUE = "unwindFromMGDVC"

/// Segue for unwinding from Dream detail view.
let UNWIND_FROM_DDVC_SEGUE = "unwindFromDDVC"

/// Segue for going to reset password from log in.
let GO_TO_RESET_PW_SEGUE = "goToResetPassword"

/// Segue for skipping tutorial
let GO_TO_INITIAL_SETUP = "goToInitialSetup"

/// Segue for going from first Initial Setup view to second Initial Setup view
let GO_TO_SECOND_INITIAL_SETUP = "goToInitialSetupSecond"

/// Segue InitialSetup -> Tab Bar
let GO_TO_TAB_BAR_SEGUE = "goToTabBar"

/// Settings -> Tab Bar
let UNWIND_FROM_SETTINGS_SEGUE = "unwindToTabBar"

/// change password -> settings
let UNWIND_FROM_CHANGE_PW_SEGUE = "unwindToSettings"

/// settings -> change password
let GO_TO_CHANGE_PASSWORD_SEGUE = "goToChangePassword"

/// Settings -> Log in
let GO_TO_LOG_IN = "logOut"

/// Segue for adding a new dream.
let ADD_DREAM_SEGUE = "addDream"

/// Segue for editing a dream.
let EDIT_DREAM_SEGUE = "editDream"

/// Segue for going from history view to review view
let GO_TO_REVIEW_SEGUE = "goToMonthlyReview"

/// Segue for going from first MR view to second MR view
let GO_TO_SECOND_REVIEW_SEGUE = "goToMonthlyReviewSecond"

/// Segue for going from history tab to initial review summary
let GO_TO_INITIAL_REVIEW_SEGUE = "goToInitialReviewSummary"

/// Unwind segue from monthly review to history
let UNWIND_TO_HISTORY_SEGUE = "unwindToHistory"

/// Go to history
let GO_TO_HISTORY_SEGUE = "goToHistory"

/// Go to summary from history
let GO_TO_SUMMARY_SEGUE = "goToSummary"

/// Go to second summary view from first summary view.
let GO_TO_SECOND_SUMMARY_SEGUE = "goToSummarySecond"

/// Delete Account -> Log in
let UNWIND_FROM_DA_SEGUE = "unwindToLogIn"

/// Settings -> Delete Account
let SETTINGS_TO_DELETE_ACCOUNT_SEGUE = "settingsToDeleteAccountSegue"

/// Settings -> Change coach email
let SETTINGS_TO_COACH_EMAIL_SEGUE = "settingsToCoachEmailSegue"

/// Settings -> Sharing
let SETTINGS_TO_SHARING_SEGUE = "settingsToSharingSegue"

/// Settings -> About
let SETTINGS_TO_ABOUT_SEGUE = "settingsToAboutSegue"

/// Settings -> Privacy Statement
let SETTINGS_TO_PRIVACY_STATEMENT = "goToPrivacyStatement"

/// Change coach email -> Settings
let UNWIND_FROM_COACH_EMAIL_SEGUE = "unwindToSettings"

/// History -> Yearly Review
let GO_TO_YEARLY_REVIEW_SEGUE = "goToYearlyReview"


// MARK: - Alert sheet strings

/// Title for goal completion alert sheet
let COMPLETION_ALERT_TITLE = "Congratulations!"

/// Message for goal completion alert sheet
let COMPLETION_ALERT_MSG = "How would you take this task to the next level?"

/// Message for goal completion alert sheet
let COMPLETION_ALERT_MSG_MONTHLY = "Do you want to set this goal as complete?"

/// Title for completion alert confirm action
let COMPLETION_ALERT_CONFIRM = "Kick it!"

/// Title for completion alert confirm action for Monthly
let COMPLETION_ALERT_CONFIRM_MONTHLY = "Yes"

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

/// Alerts user to save values
let CONFIRM_TO_SAVE_VALUES = "Do you want to save your values?"

/// Confirm saved values alert
let CONFIRM_SAVE_VALUES =  "Okay"

/// Title for saved values alert
let SAVE_VALUE_ALERT = "My Values"

/// Cancel save values
let CANCEL_SAVE_VALUES = "Cancel"

/// Review alert title
let REVIEW_ALERT_TITLE = "Monthly Review Ready"

/// Review alert message
let REVIEW_ALERT_MSG = "You have a monthly review to complete. Would you like to do it now?"

/// Review alert cancel
let REVIEW_ALERT_CANCEL = "No thanks, later."

/// Review alert confirm
let REVIEW_ALERT_CONFIRM = "Sure."

/// Add Reason placeholder string
let ADDREASON_PLACEHOLDER_STRING = "Reason for rating."

///Placeholder text for weekly goals
let WEEKLY_GOALS_PLACEHOLDER = "Click the '+' icon to add some weekly goals so you can reach your Peak Performance!"

///Placeholder text for monthly goals
let MONTHLY_GOALS_PLACEHOLDER = "Click the '+' icon to add some monthly goals so you can reach your Peak Performance!"

/// Initial setup rating reason alert controller title
let INITIAL_SETUP_ALERT_TITLE = "Your Reason"

/// Initial setup rating reason alert message
let INITIAL_SETUP_ALERT_MSG = "Please specify the reason for your rating."

/// Initial setup rating reason alert confirm
let INITIAL_SETUP_ALERT_CONFIRM = "OK"

/// Initial setup rating reason alert cancel 
let INITIAL_SETUP_ALERT_CANCEL = "Cancel"

/// Change password alert title.
let CHANGEPW_ALERT_TITLE = "Success!"

/// Change password alert message.
let CHANGEPW_ALERT_MSG = "Your password was successfully changed."

/// Change password alert confirm.
let CHANGEPW_ALERT_CONFIRM = "OK"

/// Delete account alert title.
let DELETE_ACCOUNT_ALERT_TITLE = "Delete Account"

/// Delete account alert message.
let DELETE_ACCOUNT_ALERT_MSG = "Are you sure you want to delete your account? This can't be undone."

/// Delete account alert confirm.
let DELETE_ACCOUNT_ALERT_CONFIRM = "Delete"

/// Delete account alert cancel.
let DELETE_ACCOUNT_ALERT_CANCEL = "Cancel"

/// Delete account success alert title.
let DELETE_ACCOUNT_SUCC_ALERT_TITLE = "Success!"

/// Delete account success alert message.
let DELETE_ACCOUNT_SUCC_ALERT_MSG = "Your account was successfully deleted."

/// Delete account success alert confirm,
let DELETE_ACCOUNT_SUCC_ALERT_CONFIRM = "OK"

/// Change coach email alert title.
let COACH_EMAIL_SUCC_ALERT_TITLE = "Success!"

/// Change coach email alert msg.
let COACH_EMAIL_SUCC_ALERT_MSG = "Your coach's email was successfully changed."

/// Change coach email alert confirm.
let COACH_EMAIL_SUCC_ALERT_CONFIRM = "OK"

/// No coach email alert title.
let NO_COACH_EMAIL_ALERT_TITLE = "No Coach Email!"

/// No coach email alert message.
let NO_COACH_EMAIL_ALERT_MSG = "Please set your coach's email in Settings."

/// No coach email confirm.
let NO_COACH_EMAIL_ALERT_CONFIRM = "OK"

/// Annual review alert title.
let ANNUAL_REVIEW_ALERT_MSG = "Your annual review is ready. Would you like to complete it now?"

/// Annual review alert message.
let ANNUAL_REVIEW_ALERT_TITLE = "Annual Review Ready"

/// Annual review alert confirm.
let ANNUAL_REVIEW_ALERT_CONFIRM = "Sure."

/// Annual review alert cancel.
let ANNUAL_REVIEW_ALERT_CANCEL = "No thanks, later."


// MARK: - Storyboard IDs

/// Identifier for Sign Out side menu cell
let SIGNOUT_CELL_ID = "signOut"

/// Storyboard identfier for Side Menu View Controller
let SIDE_MENU_VC = "SideMenu"

/// Identifier for Monthly Review side menu cell.
let MONTHLYREVIEW_CELL_ID = "monthlyReview"

/// Identifier for Monthly Review view controller.
let MONTHLYREVIEW_VC = "MonthlyReview"

/// Indetifier for Tab Bar View Contoller
let TAB_BAR_VC = "TabBarViewController"

/// Identifier for History Summary view controller.
let HISTORY_SUMMARY_VC = "HistorySummary"

/// Indetifier for History Goals Summary view controller.
let HISTORY_GOALS_VC = "HistoryGoals"

/// Identifier for Settings side menu cell.
let SETTINGS_CELL_ID = "settings"

/// Identifier for Settings view controller
let SETTINGS_VC = "SettingsVC"

/// Identifier for Settings nav controller
let SETTINGS_NAV = "SettingsNavController"

/// Identifier for change password settings cell.
let CHANGE_PW_CELL_ID = "changePasswordCell"

/// Identifier for change coach email settings cell.
let CHANGE_COACH_EMAIL_CELL_ID = "changeCoachEmailCell"

/// Identifier for delete account settings cell.
let DELETE_ACCOUNT_CELL_ID = "deleteAccountCell"

/// Identifier for about settings cell.
let ABOUT_CELL_ID = "aboutCell"

/// Identfier for privacy policy settings cell.
let PRIVACY_CELL_ID = "privacyPolicyCell"


// MARK: - Image Related Stuff

/// Constant for compression of JPEG UIImage representation.
let JPEG_QUALITY: CGFloat = 0.25

/// Constant for size of images to load/save to storage.
let DREAM_IMAGE_SIZE = 2 * 1024 * 1024

///Placeholder image for dream list
let DREAM_PLACEHOLDER = "dream-list-placeholder"

///Placeholder image for weekly
let WEEK_PLACEHOLDER = "weekly-placeholder"

///Placeholder image for monthly
let MONTHLY_PLACEHOLDER = "monthly-placeholder"

/// Menu icon image
let MENU_ICON_NAME = "menu-150dpi-2"

/// Menu icon highlighted image
let MENU_ICON_HIGHLIGHTED_NAME = "menu-150dpi-highlighted"

/// Icon to show when a goal is due soon
let DUE_SOON_ICON = "soon-icon"

/// Icon to show when a goal is due
let OVERDUE_ICON = "due-icon"


// MARK: - File MIME type strings

/// MIME type string for PDFs
let PDF_MIME_TYPE = "application/pdf"

// MARK: - NSUserDefaults keys

/// Key for NSUserDefaults automatic login setting
let USER_DEFAULTS_AUTO_LOGIN = "autoLogin"

/// Key for NSUserDefaults twitter integration setting
let USER_DEFAULTS_TWITTER = "twitter"


// MARK: - UILocalNotification

/// Body of WG due soon local notification
func WG_NOTIFICATION_BODY(goal: Goal) -> String { return "Weekly goal \"\(goal.goalText)\" is due." }

/// Key for ID in weekly goal notification.userSettings
let WG_NOTIFICATION_ID = "GID"

/// Body of MG due soon local notification
func MG_NOTIFICATION_BODY(monthlyGoal: MonthlyGoal) -> String { return "Monthly goal \"\(monthlyGoal.goalText)\" is due soon." }

/// Key for ID in monthly goal notification.userSettings
let MG_NOTIFICATION_ID = "MONTH"

/// Day of month to fire monthly goal notifications
let MG_NOTIFICATION_FIREDATE = 25




// MARK: - Coach email strings

/// Message displayed when trying to send summary with no coach email set
let NO_COACH_EMAIL_MESSAGE = "No coach!"

/// Summary email default body
func SUMMARY_EMAIL_BODY(month: String, user: User) -> String { return "Hi Peak Performance Coach, \nI would like to share with you my progress for the month of\(month)\nKind regards,\(user.fname)\(user.lname)" }

/// Summary email default subject
func SUMMARY_EMAIL_SUBJECT(month: String) -> String { return "My monthly review for \(month)." }


// MARK: - Social Media strings

/// Default body text for twitter posts about weekly goals
func TWITTER_MESSAGE_WEEKLY_GOAL(goal: Goal) -> String { return "I completed my goal \"\(goal.goalText)\"! #PeakPerformance"}

/// Default body text for twitter posts about monthly goals
func TWITTER_MESSAGE_MONTHLY_GOAL(goal: Goal) -> String { return "I completed my monthly goal \"\(goal.goalText)\"! #PeakPerformance"}

/// Default body text for twitter posts about dreams
func TWITTER_MESSAGE_DREAM(dream: Dream) -> String { return "My dream is to \"\(dream.dreamDesc)\" #PeakPerformance" }


// MARK: - AMPopTip constants

let FAMILY_MESSAGE_HELP = "The definition of family is different for every person and can include immediate or extended family. A value can be anything you hold to be important and it must be positive."

let FRIENDS_MESSAGE_HELP = "You may wish to consider the question of quality and quantity in relation to your friends and social life."

let PARTNER_MESSAGE_HELP = "If you have a partner, they should be considered seperately to other family members."

let WORK_MESSAGE_HELP = "Feedback received from supervisors, peers and performance reviews may be useful to consider when developing this area"

let HEALTH_MESSAGE_HELP = "These values should be about your physical well-being. The goals set in this area may vary. It's no secret that health and fitness is often the first to suffer when you are busy."

let PERSONAL_MESSAGE_HELP = "These values should relate to your general self-improvement. Such pursuits may include music, public speaking, service clubs, study in an area of interest or at work"

let FINANCE_MESSAGE_HELP = "These values can be about your household finances or investments."

let EMOTIONAL_MESSAGE_HELP = "Depending on your beliefs, your values can be in relation to your religion or philosophical belief system. A value can be anything you hold to be important and it must be positive."

// MARK: - UIColors

let PEAK_NAV_BAR_COLOR = UIColor.init(red: 54/255, green: 54/255, blue: 52/255, alpha: 1);

let PEAK_BLACK = UIColor.init(red: 54/255, green: 54/255, blue: 52/255, alpha: 1);

let PEAK_FAMILY_BLUE = UIColor.init(red: 32/355, green: 113/255, blue: 201/255, alpha: 1)


let PEAK_FRIEND_CYAN = UIColor.init(red: 101/355, green: 229/255, blue: 225/255, alpha: 1)


let PEAK_HEALTH_GREEN = UIColor.init(red: 191/355, green: 204/255, blue: 31/255, alpha: 1)

let PEAK_PARTNER_PURPLE = UIColor.init(red: 193/355, green: 36/255, blue: 198/255, alpha: 1)

let PEAK_FINANCE_BLUE_GREEN = UIColor.init(red: 47/355, green: 188/255, blue: 184/255, alpha: 1)

let PEAK_EMOTIONAL_VIOLET = UIColor.init(red: 144/355, green: 85/255, blue: 153/255, alpha: 1)

let PEAK_POPTIP_MY_VALUES_GRAY = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)

// MARK: - Pop Tips CGFloat Position

let POPTIP_OFFSET: CGFloat = -50

let POPTIP_OFFSET_MY_VALUES: CGFloat = -35

let POPTIP_MAXWIDTH: CGFloat = 60

let POPTIP_ARROW_WIDTH: CGFloat = 10

let POPTIP_ARROW_HEIGHT: CGFloat = 10

// MARK: - UITableView

/// Rowheight for goal summary cells with no kick it text.
let ROWHEIGHT_NO_KICK_IT = 53

/// Rowheight for goal summary cell with kick it text.
let ROWHEIGHT_KICK_IT = 80

/// Rowheight for top yearly summary cell when review is complete.
let ROWHEIGHT_YEARLY_COMPLETE = 0.1

/// Rowheight for top yearly summary cell when review is incomplete.
let ROWHEIGHT_YEARLY_INCOMPLETE = 228

// MARK: - History view strings

/// String for summary cell when review is ready.
let SUMMARY_CELL_REVIEW_READY = "Review ready to complete!"

/// String for summary cell when review is completed.
let SUMMARY_CELL_REVIEW_COMPLETE = "Review complete - view summary"

/// String for initial review summary cell.
let SUMMARY_CELL_INITIAL_REVIEW = "Initial Review"

/// String for intial review summary cell "view summary" text.
let SUMMARY_CELL_VIEW_INITIAL_REVIEW = "View Summary"

/// String for yearly review summary cell
let SUMMARY_CELL_YEARLY_REVIEW = "Yearly Review"



