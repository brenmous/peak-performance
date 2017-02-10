//
//  User.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 17/07/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation
import UIKit //UIAlertController

/**
    Class that represents a peak performance user.
 */
open class User
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
    var startDate: Date
    
    /// Dictionary of monthly reviews/summaries.
    var monthlySummaries = [String:MonthlySummary?]( )
    
    /// Yearly summary for annual reviews.
    var yearlySummary = [Int:YearlySummary?]()
    
    /// Currenty reality/initial summary.
    var initialSummary = CurrentRealitySummary()
    
    /// Coach email.
    var coachEmail = ""
    
    /// How many years user has been doing program.
    var year = 0
    
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
    init( fname: String, lname: String, org: String, email: String, uid: String, startDate: Date, coachEmail: String = "", year: Int = 0 )
    {
        self.fname = fname
        self.lname = lname
        self.org = org
        self.email = email
        self.uid = uid
        self.startDate = startDate
        self.coachEmail = coachEmail
        self.year = year
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
     Checks if more years have passed compared to the user's current year. If so, updates the user's current year and triggers
        a yearly review.
    
    - Returns: true if a 12 month review is required, false if otherwise.
    */
    func checkYearlyReview() -> Bool
    {
        let yearsPassedSinceStart = Date().checkTwelveMonthPeriod(self)
       
        if yearsPassedSinceStart < self.year{ fatalError(USER_YEARLY_REVIEW_FATAL_ERR_MSG) }
        
        if yearsPassedSinceStart > self.year
        {
            self.yearlySummary[self.year] = YearlySummary()
            return true
        }
        
        return false
            
    }
    
    
    /** 
     Gets all monthly reviews for the previous 12 month period. Called if it's found the user has entered a new 12 month period
     (in case they missed reviews from the previous year).
    */
    func allMonthlyReviewsFromLastYear()
    {
        let calendar = Calendar.current
        
        //check all summaries for the 12 month period
        for month in 0...11
        {
            let dateFormatter = DateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            
            let date = dateFormatter.string(from: (calendar as NSCalendar).date(byAdding: .month, value: month, to: self.startDate, options: [])!)
            
            print("MRH: checking for summary for \(date)")
            if self.monthlySummaries[date] == nil
            {
                print("MRH: no summary for \(date), creating...")
                //no summary for this month, so create one
                guard let d = dateFormatter.date(from: date) else
                {
                    print("MRH: could not create monthly summary date")
                    return
                }
                let monthlySummary = MonthlySummary(date: d)
                self.moveWeeklyGoalsFromUserToSummary(monthlySummary)
                self.moveMonthlyGoalsFromUserToSummary(monthlySummary)
                self.monthlySummaries[date] = monthlySummary
                print("MRH: created summary for \(date)")
                DataService().saveSummary(self, summary: monthlySummary)
            }
            else
            {
                print("MRH: summary for \(date) exists")
            }
        }
    }
    
    /**
     Checks a range of months from user.startMonth...currentMonth - 1 to see if those months have had their summaries created.
     If not, creates summaries and the nessecary set up for it.
     
     - Parameters:
     - allMonths: if true, get a full lot of reviews for a 12 month period.
     
     - Returns: true if a review is required, false if otherwise.
     */
    func checkMonthlyReview() -> Bool
    {
        let datesToCheck = Date( ).datesToCheckForSummaries(self)
        //let calendar = NSCalendar.currentCalendar()
        var alertUserToReview = false
        
        //for each year user has been in program, check summaries for year
        
        //check user.monthlySummaries to see if monthlySummary has been completed for that month
        for date in datesToCheck
        {
            print("MRH: checking for summary for \(date)")
            if self.monthlySummaries[date] == nil
            {
                print("MRH: no summary for \(date), creating...")
                alertUserToReview = true
                //no summary for this month, so create one
                let dateFormatter = DateFormatter( )
                //change to MONTH_YEAR_FORMAT_STRING if we want all summaries from all time
                dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
                guard let d = dateFormatter.date(from: date) else
                {
                    print("MRH: could not create monthly summary date")
                    return false
                }
                let monthlySummary = MonthlySummary(date: d)
                self.moveWeeklyGoalsFromUserToSummary(monthlySummary)
                self.moveMonthlyGoalsFromUserToSummary(monthlySummary)
                self.monthlySummaries[date] = monthlySummary
                print("MRH: created summary for \(date)")
                DataService().saveSummary(self, summary: monthlySummary)
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
    func moveWeeklyGoalsFromUserToSummary( _ monthlySummary: MonthlySummary )
    {
        let calendar = Calendar.current
        var numberOfGoalsRemoved = 0
        for (index, goal) in self.weeklyGoals.enumerated()
        {
            let goalDate = (calendar as NSCalendar).components([.month, .year], from: goal.deadline as Date)
            let summaryDate = (calendar as NSCalendar).components([.month, .year], from: monthlySummary.date as Date)
            
            //place any goals for this month in the summary array and remove them from the user array
            if (goalDate.month == summaryDate.month) //TODO: - check year (part of 12 month roll over, sprint 5)
            {
                monthlySummary.weeklyGoals.append(goal)
                //If the goal is complete, we don't need it in the User's array anymore
                if goal.complete
                {
                    DataService().removeGoal(self.uid, goal: self.weeklyGoals[index - numberOfGoalsRemoved])
                    self.weeklyGoals.remove(at: index - numberOfGoalsRemoved)
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
    func moveMonthlyGoalsFromUserToSummary( _ monthlySummary: MonthlySummary )
    {
        let calendar = Calendar.current
        var numberOfGoalsRemoved = 0
        for (index ,goal) in self.monthlyGoals.enumerated()
        {
            let goalDate = (calendar as NSCalendar).components([.month], from: goal.deadline as Date)
            let summaryDate = (calendar as NSCalendar).components([.month], from: monthlySummary.date as Date)
            
            //place any goals for this month in the summary array and remove them from the user array
            if ( goalDate.month == summaryDate.month ) //TODO: - Check year (12 month roll over)
            {
                monthlySummary.monthlyGoals.append(goal)
                //If the goal is complete, we don't need it in the User's array anymore
                if goal.complete
                {
                    DataService().removeGoal(self.uid, goal: self.monthlyGoals[index - numberOfGoalsRemoved])
                    self.monthlyGoals.remove(at: index - numberOfGoalsRemoved)
                    numberOfGoalsRemoved += 1
                }
                    //...if it isn't complete, carry it over
            }
        }
    }
}
