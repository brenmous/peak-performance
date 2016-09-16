//
//  MonthlySummary.swift
//  PeakPerformance
//
//  Created by Bren on 6/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

/**
    This class represents a summary of a user's monthly progress.
    Used for Monthly Review and History.
*/
class MonthlySummary: Summary
{
    
    /// The date of the summary (MMMM yyyy e.g. "August 2016").
    var date: NSDate //maybe string
    
    /// The completed weekly goals for this month.
    var weeklyGoals = [WeeklyGoal]( )
    
    /// The completed monthly goals for this summary.
    var monthlyGoals = [MonthlyGoal]( )
    
    /// Text of "What is working?" assessment.
    var whatIsWorking = ""
    
    /// Text of "What is not working?" assessment.
    var whatIsNotWorking = ""
    
    /// Text of "What I have improved this month?" assessment.
    var whatHaveIImproved = ""
    
    /// Text of "Do I have to change any of my..." assessment.
    var doIHaveToChange = ""
    
    /// Whether the user has reviewed this summary.
    var reviewed = false
    
    /**
        Initialises a new MonthlySummary for the specified month.
        - Parameters: 
            - month: the month of the summary.
    */
    init ( date: NSDate )
    {
        self.date = date
    }
    
}