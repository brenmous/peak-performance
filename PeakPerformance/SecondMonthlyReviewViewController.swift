//
//  SecondMonthlyReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 8/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SecondMonthlyReviewViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: MonthlySummary?
    
    // MARK: - Outlets
    @IBOutlet weak var whatIsWorkingTextView: UITextView!
    @IBOutlet weak var whatIsNotWorkingTextView: UITextView!
    @IBOutlet weak var whatHaveIImprovedTextView: UITextView!
    @IBOutlet weak var doIHaveToChangeTextView: UITextView!
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        self.updateSummaryWithText( )
        //DataService( ).saveSummary( user: User, summary: MonthlySummary )
        //go back to history view
        
    }
    
    // MARK: - Methods
    
    /// Updates the summary being reviewed with text from the text views.
    func updateSummaryWithText( )
    {
        guard let s = self.summary else
        {
            print("SMRVC: could not get summary")
            return
        }
        s.whatIsWorking = self.whatIsWorkingTextView.text
        s.whatIsNotWorking = self.whatIsNotWorkingTextView.text
        s.whatHaveIImproved = self.whatHaveIImprovedTextView.text
        s.doIHaveToChange = self.doIHaveToChangeTextView.text //TODO: - Temp. Make this radio buttons.
    }
    
    // MARK: - Overriden methods
    
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

    // MARK: - Table view data source

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
