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
    func dateComponents( date: NSDate ) -> NSDateComponents
    {
        return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
    }
    
    /// Get the number of days in the current month (28, 30 or 31).
    func numberOfDaysInCurrentMonth( ) -> Int
    {
        let range = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: self)
        return range.length
    }
    
    /// Get the current day of the month.
    private func currentDayOfMonth( ) -> Int
    {
        return self.dateComponents(NSDate( )).day
    }
    
    /// Get the month of a date as a string (dateComponents.month returns an index for non-zero indexed array of ints representing months by default).
    func monthAsString( date: NSDate ) -> String
    {
        let dateComponents = self.dateComponents(date)
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[dateComponents.month - 1]
    }
    
    /// Get the year of a date as a string.
    func yearAsString( date: NSDate ) -> String
    {
        return String(self.dateComponents(date).year)
    }
    
    /// Get the current day of the week.
    private func currentDayOfWeek( ) -> Int
    {
        let week = self.currentWeekOfMonth()
        return self.currentDayOfMonth( ) - ( ( week - 1 ) * 7 )
    }
    
    /// Get the current week of the month.
    private func currentWeekOfMonth( ) -> Int
    {
        let day = self.dateComponents(NSDate( )).day
        var week = (day/7)+1
        if day % 7 == 0
        {
            week = day/7
        }
        return week
    }
    
    /// Get the value representing the user's progress through the month (currently an increment of the bar represents one day of the current month).
    func monthlyProgressValue( ) -> Float
    {
        let increment = 100.0/Float(self.numberOfDaysInCurrentMonth( ) )
        return ( increment * Float(self.currentDayOfMonth()) ) / 100.0
    }
    
    /// Returns the string for the monthly progress bar label.
    func monthlyProgressString( ) -> String
    {
        let month = self.monthAsString(NSDate())
        let week = self.currentWeekOfMonth()
        return "\(month) Week \(week)"
    }
    
    /// Get the value representing the user's progress through the week (currently an increment of the bar represents one day of the current week).
    func weeklyProgressValue( ) -> Float
    {
        let week = self.currentWeekOfMonth()
        var increment: Float = 100.0/7.0
        //If it's the fifth (partial week)...
        if week == 5
        {
            //... if the month has 30 days (i.e. a 2 day week)
            if self.numberOfDaysInCurrentMonth() == 30
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
        return ( increment * Float(self.currentDayOfWeek()) ) / 100.0
    }
    
    /// Returns the string for the weekly progress bar label.
    func weeklyProgressString( ) -> String
    {
        let week = self.currentWeekOfMonth()
        let dayOfWeek = self.currentDayOfWeek()
        return "Week \(week) Day \(dayOfWeek)"
    }
    
    /// Returns an NSDate for specifying max date of the weekly goal deadline picker.
    func weeklyDatePickerMaxDate( ) -> NSDate
    {
        let dateComponents = self.dateComponents(NSDate())
        dateComponents.day = self.numberOfDaysInCurrentMonth()
        return NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
    }
    
    //FIXME: - Do this better (add to date while comparing to current date)
    /// Returns an array of months as strings ranging from [currentMonth...userStartMonth - 1]
    func monthlyDatePickerStringArray( startDate: NSDate ) -> [String]
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
     Checks how many years the user has been doing the program.
        - Returns: an int representing how many years the user has been doing the program.
    */
    func checkTwelveMonthPeriod(currentUser: User) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let startDate = calendar.startOfDayForDate(currentUser.startDate)
        let currentDate = self.startOfMonthForDate(calendar.startOfDayForDate(NSDate())) //12AM 01/month/year
        
        
        let dateComponents = calendar.components([.Year], fromDate: startDate, toDate: currentDate!, options: [])
        //if this is negative then user has set their system time back and everything is fucked
        return dateComponents.year
    }
    
    /**
     Gets array of months and years (as string "MMMM yyyy") that need to be checked for summaries.
     - Returns: an array of dates in string form that need to be checked.
     */
    func datesToCheckForSummaries( currentUser: User ) -> [String]
    {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = calendar.startOfDayForDate(self)
        var lastMonth = currentDate
        lastMonth = calendar.dateByAddingUnit(.Month, value: -1, toDate: lastMonth, options: [])!
        var startDate = calendar.startOfDayForDate(currentUser.startDate)
        
        //only get dates for current 12 month period, remove if we want all reviews ever
        startDate = calendar.dateByAddingUnit(.Year, value: currentUser.year, toDate: startDate, options: [])!
        
        var datesToCheck = [String]( )
        if startDate == currentDate
        {
            //still the first month so don't do anything
            print("MRH: no summaries to create")
            return datesToCheck
        }
   
        let dateFormatter = NSDateFormatter()
        //change this to MONTH_YEAR_FORMAT_STRING if we want to have all reviews ever
        dateFormatter.dateFormat = MONTH_FORMAT_STRING
        var date = startDate
        while date.compare(lastMonth) != .OrderedDescending
        {
            datesToCheck.append(dateFormatter.stringFromDate(date))
            date = calendar.dateByAddingUnit(.Month, value: 1, toDate: date, options: [])!
        }
        
        return datesToCheck
    }
    
    func daysBetweenTodayAndDate( date: NSDate ) -> Int
    {
        //get days between current date and deadline
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(date)
        let end = calendar.startOfDayForDate(self)
        let dateComponents = calendar.components([.Day], fromDate: end, toDate: start, options: [])
        return dateComponents.day
    }
    
    func monthsBetweenTodayAndDate(date: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let start = calendar.startOfDayForDate(date)
        let end = calendar.startOfDayForDate(self)
        let dateComponents = calendar.components([.Month], fromDate: end, toDate: start, options: [])
        return dateComponents.month
    }
    
    private func startOfMonthForDate(date: NSDate) -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.day = 1
        return calendar.dateFromComponents(components)
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
    
    /**
    Creates an alert informing user that their 12 month review is ready.
    - Parameters:
        - tbvc: the tab bar view controller/
    
    - Returns: an alert controller.
    */
    static func AnnualReviewAlert(tbvc: TabBarViewController) -> UIAlertController
    {
        let annualReviewAlertController = UIAlertController(title: ANNUAL_REVIEW_ALERT_TITLE, message: ANNUAL_REVIEW_ALERT_MSG, preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: ANNUAL_REVIEW_ALERT_CANCEL, style: .Cancel, handler: nil)
        let confirm = UIAlertAction(title: ANNUAL_REVIEW_ALERT_CONFIRM, style: .Default) { (action) in
            //change tab bar index to take user to history view
            tbvc.selectedIndex = 0
        }
        annualReviewAlertController.addAction(cancel) ; annualReviewAlertController.addAction(confirm)
        return annualReviewAlertController
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

// MARK: UILocalNotification

extension UILocalNotification
{
    /**
        Schedules an iOS local notification that alerts user when a weekly goal is due soon.
    
        - Parameters:
            - weeklyGoal: the goal to create a notification for.
    */
    static func createWeeklyGoalDueSoonNotification(weeklyGoal: WeeklyGoal)
    {
        let notification = UILocalNotification()
        notification.alertBody = WG_NOTIFICATION_BODY(weeklyGoal)
        
        /* Notification for due soon
        let calendar = NSCalendar.currentCalendar()
        notification.fireDate = calendar.dateByAddingUnit(.Day, value: -(weeklyGoal.daysTillDueSoon), toDate: weeklyGoal.deadline, options: [])
        */
 
        notification.fireDate = weeklyGoal.deadline
        notification.userInfo = [WG_NOTIFICATION_ID: weeklyGoal.gid]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    /**
        Deschedules the iOS local notification for a specified weekly goal.
        
        - Parameters:
            - weeklyGoal: the goal to remove the notification for.
    */
    static func removeWeeklyGoalDueSoonNotification(weeklyGoal: WeeklyGoal)
    {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        for notification in notifications
        {
            if notification.userInfo![WG_NOTIFICATION_ID] as! String == weeklyGoal.gid
            {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                return
            }
        }
    }
    
    /**
        Updates a weekly goal notification's fire date.
        
        - Parameters:
            - weeklyGoal: the goal to update the notification for.
    */
    static func updateWeeklyGoalDueSoonNotificationFireDate(weeklyGoal: WeeklyGoal)
    {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        for notification in notifications
        {
            if notification.userInfo![WG_NOTIFICATION_ID] as! String == weeklyGoal.gid
            {
                /* Notification for due soon
                let calendar = NSCalendar.currentCalendar()
                notification.fireDate = calendar.dateByAddingUnit(.Day, value: -(weeklyGoal.daysTillDueSoon), toDate: weeklyGoal.deadline, options: [])
                */
                
                notification.fireDate = weeklyGoal.deadline
                return
            }
        }
    }
}

