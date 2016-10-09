//
//  YearlySummary.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 29/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation

class YearlySummary: Summary
{
    /// Whether summary has been reviewed.
    var reviewed: Bool = false
    
    /// Text of "reasons for differences to plan" section
    var reasonsForDifferencesText = ""
    
    /// Text of "what have I observed about my performance" section
    var observedAboutPerformanceText = ""
    
    /// Text of "how have I changed my performance" section
    var changedMyPerformanceText = ""
    
}