//
//  MonthlyReviewHelper.swift
//  PeakPerformance
//
//  Created by Bren on 6/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation
import UIKit

//TODO: - save summaries to database
//TODO: - carry over incomplete goals and mark as overdue


/**
    This class handles checking if monthly summaries have been created for months and creates them if not.
*/
class MonthlyReviewHelper
{
    /// Currently logged in user.
    let currentUser: User
  
 
    
    /**
        Checks a range of months from user.startMonth...currentMonth - 1 to see if those months have had their summaries created.
        If not, creates summaries and the nessecary set up for it.
     
        - Returns: nil if no review is needed, or an alert controller if review is need.
    */
    func checkMonthlyReview( ) -> UIAlertController?
    {
        
        let datesToCheck = DateTracker( ).getDatesToCheckForSummaries( self.currentUser )
        //let calendar = NSCalendar.currentCalendar()
        var alertUserToReview = false
        
        //check user.monthlySummaries to see if monthlySummary has been completed for that month
        for date in datesToCheck
        {
            let dateAr = date.componentsSeparatedByString(" ")
            let month = dateAr[0]
            print("MRH: checking for summary for \(month)")
            if currentUser.monthlySummaries[month]! == nil
            {
                print("MRH: no summary for \(month), creating...")
                alertUserToReview = true
                //no summary for this month, so create one
                let dateFormatter = NSDateFormatter( )
                dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING //TODO: - Add year for summaries
                guard let date = dateFormatter.dateFromString(date) else
                {
                    print("MRH: could not create monthly summary date")
                    return nil
                }
                let monthlySummary = MonthlySummary(date: date)
                self.moveWeeklyGoalsFromUserToSummary(monthlySummary)
                self.moveMonthlyGoalsFromUserToSummary(monthlySummary)
                self.currentUser.monthlySummaries[month] = monthlySummary
                print("MRH: created summary for \(date)")
                DataService( ).saveSummary(currentUser, summary: monthlySummary)
            }
        }
        if alertUserToReview
        {
            return self.getReviewAlert( )
        }
        return nil
    }
    
    /** 
        Moves users weekly goals from the User objec to the MonthlySummary object.
            - Parameters:
                - monthlySummary: summary being dealt with.
     */
    func moveWeeklyGoalsFromUserToSummary( monthlySummary: MonthlySummary )
    {
        let calendar = NSCalendar.currentCalendar()
        var numberOfGoalsRemoved = 0
        for (index, goal) in currentUser.weeklyGoals.enumerate()
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
                    self.currentUser.weeklyGoals.removeAtIndex(index - numberOfGoalsRemoved)
                    numberOfGoalsRemoved += 1
                }
                //...if it isn't complete, carry it over and mark as overdue
            }
        }
    }
    
    func moveMonthlyGoalsFromUserToSummary( monthlySummary: MonthlySummary )
    {
        let calendar = NSCalendar.currentCalendar()
        var numberOfGoalsRemoved = 0
        for (index ,goal) in currentUser.monthlyGoals.enumerate()
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
                    self.currentUser.monthlyGoals.removeAtIndex(index - numberOfGoalsRemoved)
                    numberOfGoalsRemoved += 1
                }
                //...if it isn't complete, carry it over and mark as overdue
            }
        }
    }
    
    /**
        Creates an alert controller informing the user to complete their monthly review.
        - Returns: an alert controller.
    */
    func getReviewAlert( ) -> UIAlertController
    {
        let reviewAlertController = UIAlertController(title: REVIEW_ALERT_TITLE, message: REVIEW_ALERT_MSG, preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: REVIEW_ALERT_CANCEL, style: .Cancel, handler: nil )
        let confirm = UIAlertAction(title: REVIEW_ALERT_CONFIRM, style: .Default ) { (action) in
            //take user to history to complete review
            print("MRH: go to history - work in progress")
        }
        reviewAlertController.addAction(confirm); reviewAlertController.addAction(cancel)
        return reviewAlertController
    }
    
    init ( user: User )
    {
        self.currentUser = user
    }
}