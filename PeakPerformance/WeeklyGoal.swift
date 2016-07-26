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
class WeeklyGoal
{
    /// The text of the weekly goal.
    var goalText: String
    
    /// The key life area of the weekly goal.
    var kla: KeyLifeArea
    
    /// The deadline of the weekly goal.
    var deadline: NSDate
    
    /// Unique ID of the weekly goal.
    var wgid: String
    
    /**
    Initialises a new weekly goal.
    
    - Parameters:
        - goalText: the text of the weekly goal.
        - kla: the key life area of the weekly goal.
        - deadline: the deadline of the weekly goal.
    
    - Returns: A weekly goal with the specified paramters.
    */
    init ( goalText: String, kla: KeyLifeArea, deadline: NSDate, wgid: String )
    {
        self.goalText = goalText
        self.kla = kla
        self.deadline = deadline
        self.wgid = wgid
    }
    
    /**
    Convenience initiliaser for creating a goal with a deadline in String format. Used when loading goals from database.
    
    - Parameters:
        - goalText: the text of the weekly goal.
        - kla: the key life area of the weekly goal.
        - deadline: the deadline of the weekly goal (in String format).
    
    - Returns: a weekly goal with the specified parameters.
     */
    convenience init ( goalText: String, kla: KeyLifeArea, deadline: String, wgid: String )
    {
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDeadline = dateFormatter.dateFromString(deadline)
        self.init( goalText: goalText, kla: kla, deadline: newDeadline!, wgid: wgid )
    }
}