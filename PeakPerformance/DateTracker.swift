//
//  DateTracker.swift
//  PeakPerformance
//
//  Created by Bren on 26/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

class DateTracker
{
    private func getDateComponents( ) -> NSDateComponents
    {
        return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate( ))
    }
    
    func getCurrentDay( ) -> Int
    {
        return self.getDateComponents().day
    }
    
    private func getNumberOfDaysInCurrentMonth( ) -> Int
    {
        let range = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: NSDate( ))
        return range.length
    }
    
    func getCurrentMonthAsString( ) -> String
    {
        let dateComponents = self.getDateComponents()
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[dateComponents.month - 1]
    }
    
    func getCurrentDayOfWeek( ) -> Int
    {
        let week = self.getCurrentWeek()
        return self.getCurrentDay( ) - ( ( week - 1 ) * 7 )
    }
    
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
    
    func getMonthlyProgress( ) -> Float
    {
        let increment = 100.0/Float(self.getNumberOfDaysInCurrentMonth( ) )
        return ( increment * Float(self.getCurrentDay()) ) / 100.0
    }
    
    func getWeeklyProgress( ) -> Float
    {
        let week = self.getCurrentWeek()
        var increment: Float = 100.0/7.0
        if week == 5
        {
            if self.getNumberOfDaysInCurrentMonth() == 30
            {
                increment = 50.0
            }
            else
            {
                increment = 33.0
            }
        }
        return ( increment * Float(self.getCurrentDayOfWeek()) ) / 100.0
        
    }
    
}