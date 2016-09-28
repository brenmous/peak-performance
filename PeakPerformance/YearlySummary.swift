//
//  YearlySummary.swift
//  PeakPerformance
//
//  Created by Bren on 29/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

class YearlySummary: Summary
{
    /// The year of this summary (with year zero being "Year 1" of the user's program)
    var year: Int
    
    init ( year: Int )
    {
        self.year = year
    }
    
}