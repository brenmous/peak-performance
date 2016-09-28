//
//  User.swift
//  PeakPerformance
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation
import UIKit //UIAlertController

/**
    Class that represents a peak performance user
 */
public class User
{
    /// User's first name.
    var fname: String
    
    /// User's last name.
    var lname: String
    
    /// User's organisation.
    var org: String
    
    /// User's email.
    var email: String
    
    /// User's unique ID.
    var uid: String
    
    /// User's weekly goals.
    var weeklyGoals = [WeeklyGoal]( )
    
    /// User's monthly goals.
    var monthlyGoals = [MonthlyGoal]( )
    
    /// User's dreams.
    var dreams = [Dream]( )
    
    /// User's KLA values.
    var values = [ KLA_FAMILY: "", KLA_WORKBUSINESS: "", KLA_PERSONALDEV: "", KLA_FINANCIAL: "",
                   KLA_FRIENDSSOCIAL: "", KLA_HEALTHFITNESS: "", KLA_EMOSPIRITUAL: "", KLA_PARTNER: "" ]
    
    /// Sign up date (MMMM yyyy e.g. "August 2016").
    var startDate: NSDate
    
    /// Dictionary of monthly reviews/summaries.
    var monthlySummaries = [String:MonthlySummary?]( )
    
    /// Current reality (initial) summary.
    var currentRealitySummary = CurrentRealitySummary( )
    
    /// Coach email.
    var coachEmail = ""
    
    /**
        Initialises a new user.

        - Parameters:
            - fname: user's first name.
            - lname: user's last name.
            - org: user's organisation.
            - email: user's email.
            - username: user's username.
            - uid: user's unique ID.
            - startDate: month and year that user signed up.
     
        - Returns: A user with the specified parameters.
    */
    init( fname: String, lname: String, org: String, email: String, uid: String, startDate: NSDate, coachEmail: String = "" )
    {
        self.fname = fname
        self.lname = lname
        self.org = org
        self.email = email
        self.uid = uid
        self.startDate = startDate
        self.coachEmail = coachEmail
    }
    
    /// Gets number of unreviewed summaries.
    func numberOfUnreviwedSummaries( ) -> Int
    {
        var count = 0
        for (_,val) in self.monthlySummaries
        {
            if let summary = val
            {
                if !summary.reviewed
                {
                    count += 1
                }
            }
        }
        return count
    }
    
    /**
     Checks a range of months from user.startMonth...currentMonth - 1 to see if those months have had their summaries created.
     If not, creates summaries and the nessecary set up for it.
     
     - Returns: true if a review is required, false if otherwise.
     */
    func checkMonthlyReview( ) -> Bool
    {
        let datesToCheck = NSDate( ).datesToCheckForSummaries( self )
        //let calendar = NSCalendar.currentCalendar()
        var alertUserToReview = false
        
        //check user.monthlySummaries to see if monthlySummary has been completed for that month
        for date in datesToCheck
        {
            //let dateAr = date.componentsSeparatedByString(" ")
            //let month = dateAr[0]
            print("MRH: checking for summary for \(date)")
            if self.monthlySummaries[date] == nil
            {
                print("MRH: no summary for \(date), creating...")
                alertUserToReview = true
                //no summary for this month, so create one
                let dateFormatter = NSDateFormatter( )
                dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING //TODO: - Add year for summaries
                guard let d = dateFormatter.dateFromString(date) else
                {
                    print("MRH: could not create monthly summary date")
                    return false
                }
                let monthlySummary = MonthlySummary(date: d)
                self.moveWeeklyGoalsFromUserToSummary(monthlySummary)
                self.moveMonthlyGoalsFromUserToSummary(monthlySummary)
                self.monthlySummaries[date] = monthlySummary
                print("MRH: created summary for \(date)")
                DataService.saveSummary(self, summary: monthlySummary)
            }
            else
            {
                print("MRH: summary for \(date) exists")
            }
        }
        return alertUserToReview
    }
    
    /**
     Moves users weekly goals from the User object to the MonthlySummary object.
     - Parameters:
     - weeklySummary: summary being dealt with.
     */
    func moveWeeklyGoalsFromUserToSummary( monthlySummary: MonthlySummary )
    {
        let calendar = NSCalendar.currentCalendar()
        var numberOfGoalsRemoved = 0
        for (index, goal) in self.weeklyGoals.enumerate()
        {
            let goalDate = calendar.components([.Month, .Year], fromDate: goal.deadline)
            let summaryDate = calendar.components([.Month, .Year], fromDate: monthlySummary.date)
            
            //place any goals for this month in the summary array and remove them from the user array
            if (goalDate.month == summaryDate.month) //TODO: - check year (part of 12 month roll over, sprint 5)
            {
                monthlySummary.weeklyGoals.append(goal)
                //If the goal is complete, we don't need it in the User's array anymore
                if goal.complete
                {
                    DataService.removeGoal(self.uid, goal: self.weeklyGoals[index - numberOfGoalsRemoved])
                    self.weeklyGoals.removeAtIndex(index - numberOfGoalsRemoved)
                    numberOfGoalsRemoved += 1
                }
                //...if it isn't complete, carry it over
            }
        }
    }
    
    /**
     Moves users Monthly goals from the User object to the MonthlySummary object.
     Also checks if monthly goal is due (yeah I know it should be part of
     - Parameters:
     - monthlySummary: summary being dealt with.
     */
    func moveMonthlyGoalsFromUserToSummary( monthlySummary: MonthlySummary )
    {
        let calendar = NSCalendar.currentCalendar()
        var numberOfGoalsRemoved = 0
        for (index ,goal) in self.monthlyGoals.enumerate()
        {
            let goalDate = calendar.components([.Month], fromDate: goal.deadline)
            let summaryDate = calendar.components([.Month], fromDate: monthlySummary.date)
            
            //place any goals for this month in the summary array and remove them from the user array
            if ( goalDate.month == summaryDate.month ) //TODO: - Check year (12 month roll over)
            {
                monthlySummary.monthlyGoals.append(goal)
                //If the goal is complete, we don't need it in the User's array anymore
                if goal.complete
                {
                    DataService.removeGoal(self.uid, goal: self.monthlyGoals[index - numberOfGoalsRemoved])
                    self.monthlyGoals.removeAtIndex(index - numberOfGoalsRemoved)
                    numberOfGoalsRemoved += 1
                }
                    //...if it isn't complete, carry it over
            }
        }
    }
}