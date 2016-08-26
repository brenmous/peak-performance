//
//  DateTracker.swift
//  PeakPerformance
//
//  Created by Bren on 26/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

/// Class that keeps track of the date and provides methods for getting monthly/weekly progress values.
class DateTracker
{
    /// Get the day, month and year components of the current date.
    private func getDateComponents( ) -> NSDateComponents
    {
        return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate( ))
    }
    
    /// Get the number of days in the current month (28, 30 or 31).
    private func getNumberOfDaysInCurrentMonth( ) -> Int
    {
        let range = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: NSDate( ))
        return range.length
    }
    
    /// Get the current day of the month.
    func getCurrentDay( ) -> Int
    {
        return self.getDateComponents().day
    }

    /// Get the current month as a string (dateComponents.month returns an index for non-zero indexed array of ints representing months by default).
    func getCurrentMonthAsString( ) -> String
    {
        let dateComponents = self.getDateComponents()
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[dateComponents.month - 1]
    }
    
    /// Get the current day of the week.
    func getCurrentDayOfWeek( ) -> Int
    {
        let week = self.getCurrentWeek()
        return self.getCurrentDay( ) - ( ( week - 1 ) * 7 )
    }
    
    /// Get the current week of the month.
    func getCurrentWeek( ) -> Int
    {
        let day = self.getDateComponents().day
        let week = (day/7) + 1
       /* If we only want 4 weeks
        if week > 4
        {
            return 4
        } */
        return week
    }
    
    /// Get the value representing the user's progress through the month (currently an increment of the bar represents one day).
    func getMonthlyProgress( ) -> Float
    {
        let increment = 100.0/Float(self.getNumberOfDaysInCurrentMonth( ) )
        return ( increment * Float(self.getCurrentDay()) ) / 100.0
    }
    
    /// Get the value representing the user's progress through the week (currently an increment of the bar represents one day of the current week).
    func getWeeklyProgress( ) -> Float
    {
        let week = self.getCurrentWeek()
        var increment: Float = 100.0/7.0
        //If it's the fifth (partial week)...
        if week == 5
        {
            //... if the month has 30 days (i.e. a 2 day week)
            if self.getNumberOfDaysInCurrentMonth() == 30
            {
                //set progress to 1/2 per day.
                increment = 50.0
            }
            //... else if the month has 31 days (i.e. a 3 day week)
            else
            {
                //set progress to 1/3 per day.
                increment = Float(1/3)
            }
        }
        return ( increment * Float(self.getCurrentDayOfWeek()) ) / 100.0
        
    }
    
}