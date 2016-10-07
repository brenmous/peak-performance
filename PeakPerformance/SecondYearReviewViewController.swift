//
//  SecondYearReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 30/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SecondYearReviewViewController: UIViewController {

    // MARK: - Properties
    
    let dataService = DataService()
    
    var currentUser: User?

    var summary: YearlySummary?
    
    // MARK: - Actions
    @IBAction func resetButtonPressed(sender: AnyObject)
    {
        summary!.reviewed = true
        self.yearlyCleanUp()
        self.performSegueWithIdentifier(UNWIND_TO_HISTORY_SEGUE, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.summary = currentUser!.yearlySummary[currentUser!.year]!! //FIXME: shebangbangbangbangbang
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /// Resets user's monthly reviews/summaries, gets new summaries for current 12 month period. Sets yearly summary to nil.
    //if we want to send the yearly review to Paul/save it for user/whatever, that will happen here.
    func yearlyCleanUp() //TOOD: - move to user class
    {
        //Save the completed yearly summary
        self.dataService.saveYearlySummary(self.currentUser!, summary: summary!)

        //Update user's year property
        let yearsPassedSinceStart = NSDate().checkTwelveMonthPeriod(self.currentUser!)
        self.currentUser!.year = yearsPassedSinceStart
        self.dataService.saveUserYear(self.currentUser!)
        
        //Wipe all the user's monthly summaries from the previous year
        //self.currentUser!.monthlySummaries = [String:MonthlySummary]( )
        //self.dataService.removeAllMonthlySummaries(self.currentUser!)
       
        //Reset weekly and monthly goals
        /*
        self.currentUser!.weeklyGoals = [WeeklyGoal]()
        self.currentUser!.monthlyGoals = [MonthlyGoal]()
        self.dataService.removeAllGoals(self.currentUser!.uid)
        */
    }
}
