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
    /// Amount of weeks from goal's deadline for it be considered "due soon".
    let weeksTillDueSoon = 1
    
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
    
    /// Checks if this goal has reached its deadline and sets its "due" property if so.
    func checkIfDue( )
    {
        //goal is complete so don't bother checking the due date
        if self.complete
        {
            return
        }
        
        //compare goal deadline with current date
        let days = NSDate().getDaysBetweenTodayAndDeadline(self.deadline)
        if days <= 0
        {
            self.due = Due.overdue
        }
        else if days > 0 && days <= weeksTillDueSoon*7
        {
            self.due = Due.soon
        }
        else
        {
            self.due = Due.notdue
        }
    }
}