//
//  UITableViewExtensions.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com on 14/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation
import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import SwiftValidator // https://github.com/jpotts18/SwiftValidator
import Firebase // https://firebase.google.com

/**
    This file contains various extensions to classes, mainly used to package methods and abstract them away from view controllers.
*/

// MARK: - UIViewController
extension UIViewController
{
    // BEN //
    /** 
        Sets up the side menu button (left bar button).
            
        - Parameters:
            - number: the badge for number of incomplete monthly reviews.
    */
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
    // END BEN //
}

extension UIViewController
{
    // BEN //
    /// Triggers when side menu button is pressed (presents the side menu).
    func leftButtonPressed(_sender: UIButton)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGrayColor()
    }
    // END BEN //
    
}

extension UITableViewController
{
    // BEN //
    /** Returns an incremental value in CGFloat for the dot to move from the origin
        - Parameters: 
            - rating: Rating from Summary KLA Rating dictionary
     
        - Returns: a CGFloat for displacing KLA dot point from origin.
    */
    static func getIncrementFromRating(rating: Double) -> CGFloat {
        
        let decimal = rating * 10
        var increment: CGFloat = 0
        if (decimal < 1.25 && decimal >= 0) {
            
            increment = 15
            
        } else if (decimal <= 2.5 && decimal > 1.25) {
            
            increment = 30
            
        } else if (decimal <= 3.85 && decimal > 2.5) {
            
            increment = 45
            
        } else if (decimal <= 5.0 && decimal > 3.85) {
            
            increment = 60
            
        } else if (decimal <= 6.35 && decimal > 5.0) {
            
            increment = 75
            
        } else if (decimal <= 7.55 && decimal > 6.35) {
            
            increment = 90
            
        } else if (decimal <= 8.80 && decimal > 7.55) {
            
            increment = 105
            
        } else if (decimal <= 10.0 && decimal > 8.8) {
            
            increment = 120
            
        }
        
        return increment
    }
    // END BEN //
}


//MARK: - SideMenu
extension SideMenuManager
{
    /** 
        Set up side menu in view controllers that should be able to display it.
        
        - Parameters: 
            - sb: current storyboard according to view controller hosting the side menu.
            - user: the currently active user.
    */
    public class func setUpSideMenu( sb: UIStoryboard, user: User )
    {
        SideMenuManager.menuLeftNavigationController = UISideMenuNavigationController( )
        SideMenuManager.menuLeftNavigationController?.navigationBarHidden = true // hides the navigation bar
        SideMenuManager.menuLeftNavigationController?.leftSide = true
        let smvc = sb.instantiateViewControllerWithIdentifier(SIDE_MENU_VC) as! SideMenuViewController
        smvc.currentUser = user
        smvc.sb = sb
        SideMenuManager.menuLeftNavigationController?.setViewControllers([smvc], animated: true)
        
        // BEN //
        // Pan Gestures
        
        SideMenuManager.menuAddPanGestureToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        
        // Customize side menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .MenuSlideIn
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuBlurEffectStyle = .Light
        SideMenuManager.menuAnimationFadeStrength = 0.5
        // END BEN //
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
        
        let currentYear = NSDate().yearAsString(NSDate())
        let nextYear = NSDate().yearAsString(NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: 1, toDate: NSDate(), options: [])!)
        if endMonth < startMonth
        {
            for i in startMonth...months.count - 1
            {
                monthlyDatePickerArray.append("\(months[i]) \(currentYear)")
            }
            
            for i in 0...endMonth
            {
                monthlyDatePickerArray.append("\(months[i]) \(nextYear)")
            }
        }
        else if endMonth > startMonth
        {
            for i in startMonth...endMonth
            {
                monthlyDatePickerArray.append("\(months[i]) \(currentYear)")
            }
        }
        else if endMonth == startMonth
        {
            monthlyDatePickerArray.append("\(months[startMonth]) \(currentYear)")
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
            return datesToCheck
        }
   
        let dateFormatter = NSDateFormatter()
        //change this to MONTH_YEAR_FORMAT_STRING if we want to have all reviews ever
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        var date = startDate
        while date.compare(lastMonth) != .OrderedDescending
        {
            datesToCheck.append(dateFormatter.stringFromDate(date))
            date = calendar.dateByAddingUnit(.Month, value: 1, toDate: date, options: [])!
        }
        
        print("CHECK THESE DATES: \(datesToCheck)")
        
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




