//
//  MonthlyGoal.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

/**
 This class represents a user's monthly goal.
 */
class MonthlyGoal: Goal
{
    /**
     Convenience initiliaser for creating a weekly goal with a deadline in String format. Used when loading goals from database.
     
     - Parameters:
     - goalText: the text of the weekly goal.
     - kla: the key life area of the weekly goal.
     - deadline: the deadline of the weekly goal (in String format).
     
     - Returns: a weekly goal with the specified parameters.
     */
    convenience init ( goalText: String, kla: String, deadline: String, gid: String, complete: Bool = false, kickItText: String = "" )
    {
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let newDeadline = dateFormatter.dateFromString(deadline)
        self.init( goalText: goalText, kla: kla, deadline: newDeadline!, gid: gid, complete: complete, kickItText: kickItText )
    }
    
    func checkIfDue( )
    {
        if self.complete
        {
            return
        }
        
        let calendar = NSCalendar.currentCalendar()
        let goalDate = calendar.components([.Month], fromDate: self.deadline)
        let summaryDate = calendar.components([.Month], fromDate: NSDate( ) )

        if ( goalDate.month == summaryDate.month )
        {
            self.due = true
        }
        else
        {
            self.due = false
        }
    }
}