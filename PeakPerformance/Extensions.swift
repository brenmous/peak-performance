//
//  UITableViewExtensions.swift
//  PeakPerformance
//
//  Created by Bren on 14/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import SwiftValidator
import Firebase

// MARK: - UIViewController
extension UIViewController
{
    //  - Loads the burger icon with the badge if a monthly review is available
    //  - Sets up a UIImage and a Highlighted UIImage and a button and assigns it to leftBarButtonItem
    //  - ENMBadgedBarButtonItem is responsible for the badge
    
    func setUpLeftBarButtonItem( number: String )
    {
        
        let image = UIImage(named: MENU_ICON_NAME)
        let highlightedImage = UIImage(named: MENU_ICON_HIGHLIGHTED_NAME)
        let button = UIButton(type: .Custom)
        
        if let knownImage = image {
            button.frame = CGRectMake(0.0, 0.0, knownImage.size.width, knownImage.size.height)
        } else {
            button.frame = CGRectZero;
        }
        
        button.setBackgroundImage(image, forState: UIControlState.Normal)
        button.setBackgroundImage(highlightedImage, forState: .Highlighted)
        button.addTarget(self,
                         action: #selector(leftButtonPressed(_:)),
                         forControlEvents: UIControlEvents.TouchUpInside)
        button.adjustsImageWhenHighlighted = true
        button.tintColor = UIColor.lightGrayColor()
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: number) // parameter value for the number inside the dot
        newBarButton.badgeValue = number  // sets the dot and the number inside
        navigationItem.leftBarButtonItem = newBarButton
    }
}

extension UIViewController
{
    // function to Bar Button item tap
    func leftButtonPressed(_sender: UIButton)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGrayColor()
    }
}


//MARK: - SideMenu
extension SideMenuManager
{
    /// Set up side menu in view controllers that should be able to display it.
    public class func setUpSideMenu( sb: UIStoryboard, user: User )
    {
        SideMenuManager.menuLeftNavigationController = UISideMenuNavigationController( )
        SideMenuManager.menuLeftNavigationController?.navigationBarHidden = true // hides the navigation bar
        SideMenuManager.menuLeftNavigationController?.leftSide = true
        let smvc = sb.instantiateViewControllerWithIdentifier(SIDE_MENU_VC) as! SideMenuViewController
        smvc.currentUser = user
        smvc.sb = sb
        SideMenuManager.menuLeftNavigationController?.setViewControllers([smvc], animated: true)

        // Pan Gestures
        
        SideMenuManager.menuAddPanGestureToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        
        // Customize side menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .MenuSlideIn
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuBlurEffectStyle = .Light
        SideMenuManager.menuAnimationFadeStrength = 0.5
    }
}


//MARK: - UITextView

// Allows UITextViews to be used with SwiftValidator.
extension UITextView: Validatable {
    
    public var validationText: String {
        return text ?? ""
    }
}


// MARK: - NSDate
/// Class that provides manipulations of NSDate to get various date components and Strings to assist with various tasks related to calendar dates.
extension NSDate
{
    /// Get the day, month and year components of a date.
    func getDateComponents( date: NSDate ) -> NSDateComponents
    {
        return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
    }
    
    /// Get the number of days in the current month (28, 30 or 31).
    func getNumberOfDaysInCurrentMonth( ) -> Int
    {
        let range = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        return range.length
    }
    
    /// Get the current day of the month.
    private func getCurrentDay( ) -> Int
    {
        return self.getDateComponents(NSDate( )).day
    }
    
    /// Get the month of a date as a string (dateComponents.month returns an index for non-zero indexed array of ints representing months by default).
    func getMonthAsString( date: NSDate ) -> String
    {
        let dateComponents = self.getDateComponents(date)
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[dateComponents.month - 1]
    }
    
    /// Get the year of a date as a string.
    func getYearAsString( date: NSDate ) -> String
    {
        return String(self.getDateComponents(date).year)
    }
    
    /// Get the current day of the week.
    private func getCurrentDayOfWeek( ) -> Int
    {
        let week = self.getCurrentWeek()
        return self.getCurrentDay( ) - ( ( week - 1 ) * 7 )
    }
    
    /// Get the current week of the month.
    private func getCurrentWeek( ) -> Int
    {
        let day = self.getDateComponents(NSDate( )).day
        var week = (day/7)+1
        if day % 7 == 0
        {
            week = day/7
        }
        return week
    }
    
    /// Get the value representing the user's progress through the month (currently an increment of the bar represents one day of the current month).
    func getMonthlyProgressValue( ) -> Float
    {
        let increment = 100.0/Float(self.getNumberOfDaysInCurrentMonth( ) )
        return ( increment * Float(self.getCurrentDay()) ) / 100.0
    }
    
    /// Returns the string for the monthly progress bar label.
    func getMonthlyProgressString( ) -> String
    {
        let month = self.getMonthAsString(NSDate())
        let week = self.getCurrentWeek()
        return "\(month) Week \(week)"
    }
    
    /// Get the value representing the user's progress through the week (currently an increment of the bar represents one day of the current week).
    func getWeeklyProgressValue( ) -> Float
    {
        let week = self.getCurrentWeek()
        var increment: Float = 100.0/7.0
        //If it's the fifth (partial week)...
        if week == 5
        {
            //... if the month has 30 days (i.e. a 2 day week)
            if self.getNumberOfDaysInCurrentMonth() == 30
            {
                //set progress to 1/2 per day.
                increment = 50.0
            }
                //... else if the month has 31 days (i.e. a 3 day week)
            else
            {
                //set progress to 1/3 per day.
                increment = Float(1/3)
            }
        }
        return ( increment * Float(self.getCurrentDayOfWeek()) ) / 100.0
    }
    
    /// Returns the string for the weekly progress bar label.
    func getWeeklyProgressString( ) -> String
    {
        let week = self.getCurrentWeek()
        let dayOfWeek = self.getCurrentDayOfWeek()
        return "Week \(week) Day \(dayOfWeek)"
    }
    
    /// Returns an NSDate for specifying max date of the weekly goal deadline picker.
    func getWeeklyDatePickerMaxDate( ) -> NSDate
    {
        let dateComponents = self.getDateComponents(NSDate())
        dateComponents.day = self.getNumberOfDaysInCurrentMonth()
        return NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
    }
    
    /// Returns an array of months as strings ranging from [currentMonth...userStartMonth - 1]
    func getMonthlyDatePickerStringArray( startDate: NSDate ) -> [String]
    {
        let startMonth = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: self ).month - 1
        var endMonth = NSCalendar.currentCalendar().components([.Month], fromDate: startDate ).month - 2
        if endMonth < 0
        {
            endMonth = 11
        }
        
        print("DT: start month = \(startMonth), end month = \(endMonth)")
        
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        var monthlyDatePickerArray = [String]( )
        
        if endMonth < startMonth
        {
            for i in startMonth...months.count - 1
            {
                monthlyDatePickerArray.append(months[i])
            }
            
            for i in 0...endMonth
            {
                monthlyDatePickerArray.append(months[i])
            }
        }
        else if endMonth > startMonth
        {
            for i in startMonth...endMonth
            {
                monthlyDatePickerArray.append(months[i])
            }
        }
        else if endMonth == startMonth
        {
            monthlyDatePickerArray.append(months[startMonth])
        }
        
        return monthlyDatePickerArray
    }
    
    /**
     Gets array of months and years (as string "MMMM yyyy") that need to be checked for summaries.
     - Returns: an array of months in string form that need to be checked.
     */
    func getDatesToCheckForSummaries( currentUser: User ) -> [String]
    {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = calendar.components([.Day, .Month, .Year], fromDate: self)
        let startDate = calendar.components([.Day, .Month, .Year], fromDate: currentUser.startDate )
        if (currentDate.month == startDate.month) && (currentDate.year == startDate.year)
        {
            //still the first month so don't do anything
            print("MRH: no summaries to create")
            return [String]( )
        }
        //build an array of month strings representing dictionary keys to check in users monthlySummaries property
        let monthsOfTheYear = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        var monthsToCheck = [String]( )
        
        let startMonth = startDate.month - 1
        let prevMonth = currentDate.month - 2
        
        print("start: \(monthsOfTheYear[startMonth])") //DEBUG
        print("prev: \(monthsOfTheYear[prevMonth])") //DEBUG
        
        if startMonth == prevMonth
        {
            monthsToCheck.append("\(monthsOfTheYear[startMonth]) \(startDate.year)")
        }
        else if startMonth < prevMonth
        {
            for i in startMonth...prevMonth
            {
                monthsToCheck.append("\(monthsOfTheYear[i]) \(startDate.year)")
            }
        }
        else
        {
            for i in startMonth...monthsOfTheYear.count-1
            {
                monthsToCheck.append("\(monthsOfTheYear[i]) \(startDate.year)")
            }
            for i in 0...prevMonth
            {
                monthsToCheck.append("\(monthsOfTheYear[i]) \(startDate.year+1)")
            }
        }
        return monthsToCheck
    }
    
    func getDaysBetweenTodayAndDeadline( deadline: NSDate ) -> Int
    {
        //get days between current date and deadline
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(deadline)
        let end = calendar.startOfDayForDate(self)
        let dateComponents = calendar.components([.Day], fromDate: end, toDate: start, options: [])
        return dateComponents.day
    }
    
    func userStartdateMonths(startDate: NSDate) -> Int
    {
        //get days between current date and deadline
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(startDate)
        let end = calendar.startOfDayForDate(self)
        let dateComponents = calendar.components([.Month], fromDate: end, toDate: start, options: [])
        return dateComponents.month
    }
}

// MARK: - UIAlertController

extension UIAlertController
{
    /**
     Creates an alert controller informing the user to complete their monthly review.
     - Returns: an alert controller.
     */
    static func getReviewAlert(tbvc: TabBarViewController) -> UIAlertController
    {
        let reviewAlertController = UIAlertController(title: REVIEW_ALERT_TITLE, message: REVIEW_ALERT_MSG, preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: REVIEW_ALERT_CANCEL, style: .Cancel, handler: nil )
        let confirm = UIAlertAction(title: REVIEW_ALERT_CONFIRM, style: .Default ) { (action) in
            //take user to history to complete review
            tbvc.selectedIndex = 0
            
        }
        reviewAlertController.addAction(confirm); reviewAlertController.addAction(cancel)
        return reviewAlertController
    }
    
    /**
     Creates an alert controller informing the user that their password change was successful.
     - Returns: an alert controller.
     */
    static func getChangePasswordAlert(cpvc: ChangePasswordViewController) -> UIAlertController
    {
        let changePWAlertController = UIAlertController(title: CHANGEPW_ALERT_TITLE, message: CHANGEPW_ALERT_MSG, preferredStyle: .ActionSheet)
        let confirm = UIAlertAction(title: CHANGEPW_ALERT_CONFIRM, style: .Default) { (action) in
            cpvc.performSegueWithIdentifier(UNWIND_FROM_CHANGE_PW_SEGUE, sender: cpvc)
        }
        
        changePWAlertController.addAction(confirm)
        
        return changePWAlertController
    }
    
    /**
     Creates an alert controller asking user to confirm account deletion.
     - Returns: an alert controller.
     */
    static func getDeleteAccountAlert(davc: DeleteAccountViewController) -> UIAlertController
    {
        let deleteAccountAlertController = UIAlertController(title: DELETE_ACCOUNT_ALERT_TITLE, message: DELETE_ACCOUNT_ALERT_MSG, preferredStyle: .ActionSheet)
        let confirm = UIAlertAction(title: DELETE_ACCOUNT_ALERT_CONFIRM, style: .Destructive) { (action) in
            davc.deleteAccount()
        }
        let cancel = UIAlertAction(title: DELETE_ACCOUNT_ALERT_CANCEL, style: .Cancel ) { (action) in
            print("DAVC - deleteAccount(): user cancelled deletion")
            davc.activityIndicator.stopAnimating()
            davc.navigationItem.rightBarButtonItem?.enabled = true
            davc.passwordField.text = ""
            davc.confirmPasswordField.text = ""
        }
        
        deleteAccountAlertController.addAction(confirm); deleteAccountAlertController.addAction(cancel)
        
        return deleteAccountAlertController
    }
    
    /**
     Creates an alert controller informing the user that account deletion was successful.
     - Returns: an alert controller.
     */
    static func getDeleteAccountSuccessAlert(davc: DeleteAccountViewController) -> UIAlertController
    {
        let deleteAccountSuccessAlertController = UIAlertController(title: DELETE_ACCOUNT_SUCC_ALERT_TITLE, message: DELETE_ACCOUNT_SUCC_ALERT_MSG, preferredStyle: .ActionSheet)
        let confirm = UIAlertAction(title: DELETE_ACCOUNT_SUCC_ALERT_CONFIRM, style: .Default) { (action) in
            let smnav = davc.presentingViewController as! UISideMenuNavigationController
            let sm = smnav.viewControllers[0]
            sm.dismissViewControllerAnimated(false) {
            
                sm.performSegueWithIdentifier(UNWIND_TO_LOGIN, sender: sm)
            }
        }
        
        deleteAccountSuccessAlertController.addAction(confirm)
        
        return deleteAccountSuccessAlertController
    }
    
    /**
    Creates an alert controller informing user that change of coach email was successful.
    - Parameters:
        - cevc: the change coach email view controller.
 
    - Returns: an alert controller.
    */
    static func getChangeCoachEmailSuccessAlert(cevc: CoachEmailViewController) -> UIAlertController
    {
        let changeCoachEmailSucccessAlertController = UIAlertController(title: COACH_EMAIL_SUCC_ALERT_TITLE, message: COACH_EMAIL_SUCC_ALERT_MSG, preferredStyle: .ActionSheet)
        
        let confirm = UIAlertAction(title: COACH_EMAIL_SUCC_ALERT_CONFIRM, style: .Default) { (action) in
            cevc.performSegueWithIdentifier(UNWIND_FROM_COACH_EMAIL_SEGUE, sender: cevc)
        }
        
        changeCoachEmailSucccessAlertController.addAction(confirm)
        
        return changeCoachEmailSucccessAlertController
    }
    
    /**
    Creates an alert informing user that mail can't be sent because no coach email has been supplied.
    - Parameters:
        - hvc: the History view controller.
    
    - Returns: an alert controller
    */
    static func getNoCoachEmailAlert(hvc: HistoryViewController) -> UIAlertController
    {
        let noCoachEmailAlertController = UIAlertController(title: NO_COACH_EMAIL_ALERT_TITLE, message: NO_COACH_EMAIL_ALERT_MSG, preferredStyle: .ActionSheet)
        let confirm = UIAlertAction(title: NO_COACH_EMAIL_ALERT_CONFIRM, style: .Default, handler: nil)
        
        noCoachEmailAlertController.addAction(confirm)
        
        return noCoachEmailAlertController
    }
}

extension FIRAuth
{ /*
    /// Reauthenticates the current user
    func reauthenticate(currentUser: User, password: String )
    {
        print("DAVC - deleteAccount(): attemping to reauthenticate user...")
        guard let cu = currentUser else
        {
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credentialWithEmail(currentUser.email, password: password)
        user?.reauthenticateWithCredential(credential) { (error) in
            guard let error = error else
            {
                //reauth successful
                print("CPVC - reauthUser(): auth successful")
                self.activityIndicator.stopAnimating()
                self.loadScreenBackground.hidden = true
                
                //show destructive alert
                self.presentViewController(UIAlertController.getDeleteAccountAlert(self), animated: true, completion: nil)
                
                return
            }
            //handle reauth error
            guard let errCode = FIRAuthErrorCode( rawValue: error.code) else
            {
                return
            }
            print("CPVC - reauthUser(): auth failed")
            self.loadScreenBackground.hidden = true
            self.activityIndicator.stopAnimating()
            
            switch errCode
            {
            case .ErrorCodeUserNotFound:
                self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
                
            case .ErrorCodeTooManyRequests:
                self.deleteAccountErrorLabel.text = REQUEST_ERR_MSG
                
            case .ErrorCodeNetworkError:
                self.deleteAccountErrorLabel.text = NETWORK_ERR_MSG
                
            case .ErrorCodeInternalError:
                self.deleteAccountErrorLabel.text = FIR_INTERNAL_ERROR
                
            case .ErrorCodeUserDisabled:
                self.deleteAccountErrorLabel.text = USER_DISABLED_ERROR
                
            case .ErrorCodeWrongPassword:
                self.deleteAccountErrorLabel.text = CHANGE_PW_ERROR
                
            case .ErrorCodeUserMismatch:
                self.deleteAccountErrorLabel.text = LOGIN_ERR_MSG
                
            default:
                print("CPVC - reauthUser(): error case not currently covered - \(error.localizedDescription)") //DEBUG
                self.deleteAccountErrorLabel.text = "Error case not currently covered." //DEBUG
            }
            self.deleteAccountErrorLabel.hidden = false
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    } */
}

