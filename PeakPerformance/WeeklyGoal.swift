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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDeadline = dateFormatter.dateFromString(deadline)
        self.init( goalText: goalText, kla: kla, deadline: newDeadline!, gid: gid, complete: complete, kickItText: kickItText)
    }
}