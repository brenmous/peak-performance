//
//  SecondYearReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 30/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

class SecondYearReviewViewController: UIViewController {

    // MARK: - Properties
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// Currently authenticated user.
    var currentUser: User?

    /// The yearly summary being completed.
    var summary: YearlySummary?
    
    // MARK: - Actions
    @IBAction func resetButtonPressed(_ sender: AnyObject)
    {
        summary!.reviewed = true
        self.yearlyCleanUp()
        self.performSegue(withIdentifier: UNWIND_TO_HISTORY_SEGUE, sender: self)
    }
    
    // MARK: - Methods
    
    /// Resets user's monthly reviews/summaries, gets new summaries for current 12 month period. Sets yearly summary to nil.
    func yearlyCleanUp()
    {
        //Save the completed yearly summary
        self.dataService.saveYearlySummary(self.currentUser!, summary: summary!)

        //Update user's year property
        let yearsPassedSinceStart = Date().checkTwelveMonthPeriod(self.currentUser!)
        self.currentUser!.year = yearsPassedSinceStart
        self.dataService.saveUserYear(self.currentUser!)
    }
    
    // MARK: - Overriden methods
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.summary = currentUser!.yearlySummary[currentUser!.year]!! //FIXME: shebangbangbangbangbang
    }
}
