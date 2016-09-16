//
//  User.swift
//  PeakPerformance
//
//  Created by Bren on 17/07/2016.
//  Copyright © 2016 Bren. All rights reserved.
//

import Foundation

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
    var monthlySummaries: [String:MonthlySummary?] = ["January": nil, "February": nil, "March": nil, "April": nil,
                                                      "May": nil, "June": nil, "July": nil, "August": nil, "September": nil,
                                                      "October": nil, "November": nil, "December": nil]
    

    
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
    init( fname: String, lname: String, org: String, email: String, uid: String, startDate: NSDate )
    {
        self.fname = fname
        self.lname = lname
        self.org = org
        self.email = email
        self.uid = uid
        self.startDate = startDate
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
}