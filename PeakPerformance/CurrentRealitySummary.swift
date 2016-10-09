//
//  CurrentRealitySummary.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 16/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation

class CurrentRealitySummary: Summary
{
    /// Reasons for supplied ratings.
    var klaReasons = [ KLA_FAMILY: "", KLA_WORKBUSINESS: "", KLA_PERSONALDEV: "", KLA_FINANCIAL: "",
                       KLA_FRIENDSSOCIAL: "", KLA_HEALTHFITNESS: "", KLA_EMOSPIRITUAL: "", KLA_PARTNER: "" ]
}