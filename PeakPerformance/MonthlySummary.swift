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
class MonthlySummary
{
    
    /// The date of the summary (MMMM yyyy e.g. "August 2016").
    var date: NSDate //maybe string
    
    /// The weekly goals contained within the month.
    var weeklyGoals = [WeeklyGoal]( )
    
    /// Rating of each key life area.
    var klaRatings = [ KLA_FAMILY: 0, KLA_WORKBUSINESS: 0, KLA_PERSONALDEV: 0, KLA_FINANCIAL: 0,
                                    KLA_FRIENDSSOCIAL: 0, KLA_HEALTHFITNESS: 0, KLA_EMOSPIRITUAL: 0, KLA_PARTNER: 0 ]
    
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