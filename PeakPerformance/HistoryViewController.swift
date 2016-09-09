//
//  HistoryViewController.swift
//  PeakPerformance
//
//  Created by Bren on 6/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu

class HistoryViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    var monthlySummariesArray = [MonthlySummary]( )
    
    // MARK: - Actions
    @IBAction func menuButtonPressed(sender: AnyObject) {
        self.presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromMonthlyReview(sender: UIStoryboardSegue){}
    
    // MARK: - Overridden methods
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.currentUser == nil
        {
            //Get data from tab bar view controller
            let tbvc = self.tabBarController as! TabBarViewController
            
            guard let cu = tbvc.currentUser else
            {
                return
            }
            self.currentUser = cu
        }
        
        //place summaries from user dictionary into array (required for table view)
        //TODO: - use observer to only update array when summaries are added
        self.monthlySummariesArray = [MonthlySummary]( ) //this is pretty dirty
        for (_, val) in self.currentUser!.monthlySummaries
        {
            if val != nil
            {
                self.monthlySummariesArray.append(val!)
            }
        }

        //sort summaries by date with most oldest first
        //currentUser!.weeklyGoals.sortInPlace({!$0.complete && $1.complete})
        
        //set up side menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: currentUser! ) //func declaration is in SideMenuViewController
        
        /*
         let alert = MonthlyReviewHelper(user: self.currentUser!).checkMonthlyReview()
         if alert != nil
         {
         self.presentViewController(alert!, animated: true, completion: nil)
         }*/
        
        //reload the view
        self.tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.monthlySummariesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> HistoryTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        let summary = self.monthlySummariesArray[indexPath.row]
        //print("WGVC: reconfiguring cells") //DEBUG
        // Configure the cell...

        //hide the "review ready" label (or icon or whatever)
        //cell.reviewReadyLabel.hidden = true
        
        //set month label
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = MONTH_FORMAT_STRING
        let monthAsString = dateFormatter.stringFromDate(summary.date)
        cell.monthLabel.text = monthAsString
        
        //set "review ready" label
        if summary.reviewed == false
        {
            cell.reviewReadyLabel.text = "Review ready to complete!" //make constant
            cell.reviewReadyLabel.textColor = UIColor.magentaColor()
        }
        else
        {
            cell.reviewReadyLabel.text = "Review complete - view summary" //make constant
            cell.reviewReadyLabel.textColor = UIColor.blackColor( )
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let summary = self.monthlySummariesArray[indexPath.row]
        
        //determine selected cell and perform associated action.
        if summary.reviewed == false
        {
            //go to review for summary
            performSegueWithIdentifier(GO_TO_REVIEW_SEGUE, sender: self)
        }
        else
        {
            //go to history for summary
           // performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
        }
        else if editingStyle == .Insert
        {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == GO_TO_REVIEW_SEGUE
        {
            print("HVC: going to review view")
            let dvc = segue.destinationViewController as! MonthlyReviewViewController
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = self.monthlySummariesArray[indexPath.row]
            }
            
        }
    }

}
