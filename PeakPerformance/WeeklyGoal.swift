//
//  WeeklyGoal.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

/**
  This class represents a user's weekly goal.
  */
class WeeklyGoal: Goal
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
        dateFormatter.dateFormat = DAY_MONTH_YEAR_FORMAT_STRING
        let newDeadline = dateFormatter.dateFromString(deadline)
        self.init( goalText: goalText, kla: kla, deadline: newDeadline!, gid: gid, complete: complete, kickItText: kickItText )
    }
    
    /** 
        Gets what week of the month this goal falls in.
 
        - Returns: an Int from 1 to 5 representing the week of the month the goal deadline falls in.
    */
    func getWeekOfGoal( ) -> Int
    {
        let day = NSCalendar.currentCalendar().component(.Day, fromDate: self.deadline)
        var week = (day/7)+1
        if day % 7 == 0
        {
            week = day/7
        }
        return week
    }
    
    
    /// Checks if this goal has reached its deadline and sets its "due" property if so.
    func checkIfDue( )
    {
        //goal is complete/aready due so don't bother checking the due date
        if self.complete || self.due
        {
            return
        }
        
        //compare goal deadline with current date
        let res = self.deadline.compare(NSDate( ))
        if res == .OrderedAscending
        {
            self.due = true
        }
    }
}