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
    var complete: Bool = false
    
    /// "Kick it to the next level" text
    var kickItText: String = ""
    
    /// Whether the goal has reached its deadline.
    var due: Due = .notdue
    
    enum Due
    {
        case notdue
        case soon
        case overdue
    }
    
    /**
     Initialises a new weekly goal.
     
     - Parameters:
     - goalText: the text of the weekly goal.
     - kla: the key life area of the weekly goal.
     - deadline: the deadline of the weekly goal.
     - compelte: whether the goal has been completed.
     
     - Returns: A weekly goal with the specified paramters.
     */
    init ( goalText: String, kla: String, deadline: NSDate, gid: String, complete: Bool = false, kickItText: String = "", due: Due = .notdue )
    {
        self.goalText = goalText
        self.kla = kla
        self.deadline = deadline
        self.gid = gid
        self.complete = complete
        self.kickItText = kickItText
        self.due = due
    }
}