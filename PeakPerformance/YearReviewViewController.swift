//
//  YearReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren Moushall on 29/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit

class YearReviewViewController: UITableViewController {

    // MARK: - Properties
    
    /// The currently authenticated user.
    var currentUser: User?
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The yearly summary being dealt with.
    var summary: YearlySummary?
    
    // MARK: - Outlets
    @IBOutlet weak var reasonsForDifferencesTextView: UITextView!
    
    @IBOutlet weak var observedAboutMyPerformanceTextView: UITextView!
    
    @IBOutlet weak var changedMyPerformance: UITextView!
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        //guard let summary = currentUser!.yearlySummary[currentUser!.year] else { return }
        guard let summary = self.summary else { return }
        summary.reviewed = true
        self.yearlyCleanUp()
        self.performSegueWithIdentifier(UNWIND_TO_HISTORY_SEGUE, sender: self)
    }
    
    // MARK: - Methods
    /// Resets user's monthly reviews/summaries, gets new summaries for current 12 month period. Sets yearly summary to nil.
    func yearlyCleanUp()
    {
        //guard let summary = currentUser!.yearlySummary[currentUser!.year] else { return }
        guard let summary = self.summary else { return }
        //Save the completed yearly summary
        self.dataService.saveYearlySummary(self.currentUser!, summary: summary)
        
        //Update user's year property
        let yearsPassedSinceStart = NSDate().checkTwelveMonthPeriod(self.currentUser!)
        self.currentUser!.year = yearsPassedSinceStart
        self.dataService.saveUserYear(self.currentUser!)
    }
    
    // MARK: - Overriden methods
    override func viewDidLoad()
    {
        
        self.navigationController!.navigationBar.tintColor = PEAK_NAV_BAR_COLOR
        
        guard let summary = self.summary else { return }
        //If the summary has been reviwed, hide the graphic, place summary text in fields and disable/hide "Done" button.
        if summary.reviewed
        {
            reasonsForDifferencesTextView.text = summary.reasonsForDifferencesText
            observedAboutMyPerformanceTextView.text = summary.observedAboutPerformanceText
            changedMyPerformance.text = summary.changedMyPerformanceText
            reasonsForDifferencesTextView.editable = false
            observedAboutMyPerformanceTextView.editable = false
            changedMyPerformance.editable = false
            
            let doneButton = self.navigationItem.rightBarButtonItem
            doneButton?.title = ""
            doneButton?.enabled = false
            
        }
    }
    

}
