//
//  Goal.swift
//  PeakPerformance
//
//  Created by Bren on 24/07/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

/**
 This class represents a user goal.
 */
class Goal
{
    /// The text of the weekly goal.
    var goalText: String
    
    /// The key life area of the weekly goal.
    var kla: String
    
    /// The deadline of the weekly goal.
    var deadline: NSDate
    
    /// Unique ID of the goal.
    var gid: String
    
    /// Whether the goal has been completed.
    var complete: Bool
    
    /**
     Initialises a new weekly goal.
     
     - Parameters:
     - goalText: the text of the weekly goal.
     - kla: the key life area of the weekly goal.
     - deadline: the deadline of the weekly goal.
     - compelte: whether the goal has been completed.
     
     - Returns: A weekly goal with the specified paramters.
     */
    init ( goalText: String, kla: String, deadline: NSDate, gid: String, complete: Bool = false)
    {
        self.goalText = goalText
        self.kla = kla
        self.deadline = deadline
        self.gid = gid
        self.complete = complete
    }
    
    /**
     Convenience initiliaser for creating a goal with a deadline in String format. Used when loading goals from database.
     
     - Parameters:
     - goalText: the text of the weekly goal.
     - kla: the key life area of the weekly goal.
     - deadline: the deadline of the weekly goal (in String format).
     
     - Returns: a weekly goal with the specified parameters.
     */
    convenience init ( goalText: String, kla: String, deadline: String, gid: String, complete: Bool = false )
    {
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDeadline = dateFormatter.dateFromString(deadline)
        self.init( goalText: goalText, kla: kla, deadline: newDeadline!, gid: gid, complete: complete )
    }
}