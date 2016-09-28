//
//  YearReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 29/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class YearReviewViewController: UITableViewController {

    // MARK: - Properties
    var currentUser: User?
    
    // MARK: - Actions 
    //temp code, comment out if needed but please do not remove - I need it for later
    @IBAction func nextButtonPressed( )
    {
        self.yearlyCleanUp()
     
        self.performSegueWithIdentifier(UNWIND_TO_HISTORY_SEGUE, sender: self)
  
        
    }
    
    // MARK: - Methods
    /// Resets user's monthly reviews/summaries, gets new summaries for current 12 month period. Sets yearly summary to nil.
    //if we want to send the yearly review to Paul/save it for user/whatever, that will happen here.
    func yearlyCleanUp()
    {
        let yearsPassedSinceStart = NSDate().checkTwelveMonthPeriod(self.currentUser!)
        self.currentUser!.year = yearsPassedSinceStart
        DataService.saveUserYear(self.currentUser!)
        self.currentUser!.monthlySummaries = [String:MonthlySummary]( )
        //get new summaries (if any months have passed in the new 12 month period)
        self.currentUser!.checkMonthlyReview()
        self.currentUser!.yearlySummary = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
