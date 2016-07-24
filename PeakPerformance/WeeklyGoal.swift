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
    
    /**
    Initialises a new weekly goal.
    
    - Parameters:
        - goalText: the text of the weekly goal.
        - kla: the key life area of the weekly goal.
        - deadline: the deadline of the weekly goal.
    
    - Returns: A weekly goal with the specified paramters.
    */
    init ( goalText: String, kla: KeyLifeArea, deadline: NSDate )
    {
        self.goalText = goalText
        self.kla = kla
        self.deadline = deadline
    }
    
}