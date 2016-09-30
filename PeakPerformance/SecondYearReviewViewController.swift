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
    var currentUser: User?
    
    
    // MARK: - Actions
    @IBAction func resetButtonPressed(sender: AnyObject)
    {
        (self.currentUser!.yearlySummary as! YearlySummary).reviewed = true
        self.yearlyCleanUp()
        self.performSegueWithIdentifier(UNWIND_TO_HISTORY_SEGUE, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /// Resets user's monthly reviews/summaries, gets new summaries for current 12 month period. Sets yearly summary to nil.
    //if we want to send the yearly review to Paul/save it for user/whatever, that will happen here.
    func yearlyCleanUp() //TOOD: - move to user class
    {
        //Update user's year property
        let yearsPassedSinceStart = NSDate().checkTwelveMonthPeriod(self.currentUser!)
        self.currentUser!.year = yearsPassedSinceStart
        DataService.saveUserYear(self.currentUser!)
        
        //Wipe all the user's monthly summaries from the previous year
        self.currentUser!.monthlySummaries = [String:MonthlySummary]( )
        DataService.removeAllMonthlySummaries(self.currentUser!)
        
        //Save the completed yearly summary
        DataService.saveYearlySummary(self.currentUser!, summary: self.currentUser!.yearlySummary! as! YearlySummary)
        
        //Reset weekly and monthly goals
        self.currentUser!.weeklyGoals = [WeeklyGoal]()
        self.currentUser!.monthlyGoals = [MonthlyGoal]()
        DataService.removeAllGoals(self.currentUser!.uid)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
