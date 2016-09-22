//
//  HistoryViewController.swift
//  PeakPerformance
//
//  Created by Bren on 6/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI

//TODO: - display cell for currenty reality summary
//TODO: - display cells in yearly sections, preferably collapsible (12 month roll over)

class HistoryViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    /// The currently logged in user.
    var currentUser: User?
    
    var monthlySummariesArray = [Summary]( )
    
    var summaryToSend: MonthlySummary?
    
    // MARK: - Actions
    @IBAction func menuButtonPressed(sender: AnyObject) {
        self.presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func sendEmailToCoachPressed(sender: AnyObject )
    {
        let mailVC = MFMailComposeViewController( )
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["bmoush@gmail.com"]) //TODO: set to User's coach email
        
        //get month of selected summary and set as email subject
        let button = sender as! UIButton
        let cell = button.superview!.superview as! HistoryTableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let summary = self.monthlySummariesArray[indexPath!.row] as! MonthlySummary
        let month = NSDate( ).getMonthAsString(summary.date)
        let subject = "My monthly review for \(month)." //TODO: make constant
        mailVC.setSubject(subject)
        
        //mailVC.addAttachmentData(<#T##attachment: NSData##NSData#>, mimeType: <#T##String#>, fileName: <#T##String#>)
        
        self.summaryToSend = summary
       
        if MFMailComposeViewController.canSendMail()
        {
            self.presentViewController(mailVC, animated: true, completion: nil)
        }
        else
        {
            //show error alert
            print("HVC: error with email")
        }
        
    }
    
    @IBAction func unwindToHistory(sender: UIStoryboardSegue){}
    
    // MARK: - Methods
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
        if error == nil
        {
            //all is well
            self.summaryToSend!.sent = true
            DataService.saveSummary(self.currentUser!, summary: self.summaryToSend!)
            self.summaryToSend = nil
            self.tableView!.reloadData( )
        }
    }
    
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
        self.monthlySummariesArray.removeAll() //this is dirty, fix it
        for (_, val) in self.currentUser!.monthlySummaries
        {
            if val != nil
            {
                self.monthlySummariesArray.append(val!)
            }
        }

        //sort summaries by date with oldest first
        //currentUser!.weeklyGoals.sortInPlace({!$0.complete && $1.complete})
        self.monthlySummariesArray.sortInPlace({($0 as! MonthlySummary).date.compare(($1 as! MonthlySummary).date) == .OrderedAscending })
        self.monthlySummariesArray.insert(self.currentUser!.currentRealitySummary, atIndex: 0)
        
        //set up side menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: currentUser! ) //func declaration is in SideMenuViewController
        
        
        
        //check if a monthly review is needed
        if self.currentUser!.checkMonthlyReview()
        {
            self.presentViewController(UIAlertController.getReviewAlert( ), animated: true, completion: nil)
        }
        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        self.tableView.reloadData( )
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
        let s = self.monthlySummariesArray[indexPath.row]

        if s is MonthlySummary
        {
            let summary = s as! MonthlySummary
            //set month label
            let dateFormatter = NSDateFormatter( )
            dateFormatter.dateFormat = MONTH_FORMAT_STRING
            let monthAsString = dateFormatter.stringFromDate(summary.date)
            cell.monthLabel.text = monthAsString
            
            //send to coach button
            if !summary.sent
            {
                cell.sendToCoachButton.hidden = false
            }
            else
            {
                cell.sendToCoachButton.hidden = true
            }
            
            //set "review ready" label
            if summary.reviewed == false
            {
                cell.reviewReadyLabel.text = "Review ready to complete!" //TODO: - make constant
                cell.reviewReadyLabel.textColor = UIColor.init(red: 143/255, green: 87/255, blue: 152/255, alpha: 1)
            }
            else
            {
                cell.reviewReadyLabel.text = "Review complete - view summary" //TODO: - make constant
                cell.reviewReadyLabel.textColor = UIColor.grayColor()
            }
        }
        else if s is CurrentRealitySummary
        {
            //let summary = s as! CurrentRealitySummary
            cell.sendToCoachButton.hidden = true
            cell.reviewReadyLabel.text = "View summary"
            cell.monthLabel.text = "Initial Review" //change this to whatever you want
            cell.reviewReadyLabel.textColor = UIColor.grayColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let s = self.monthlySummariesArray[indexPath.row]
        
        if s is MonthlySummary
        {
            let summary = s as! MonthlySummary
            
            //determine selected cell and perform associated action.
            if summary.reviewed == false
            {
                //go to review for summary
                performSegueWithIdentifier(GO_TO_REVIEW_SEGUE, sender: self)
                return
            }
            else
            {
                performSegueWithIdentifier(GO_TO_SUMMARY_SEGUE, sender: self)
            }
        }
       
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
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
                dvc.summary = self.monthlySummariesArray[indexPath.row] as? MonthlySummary
            }
        }
        else if segue.identifier == GO_TO_SUMMARY_SEGUE
        {
            print("HVC: going to summary view")
            let dvc = segue.destinationViewController as! SummaryViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = self.monthlySummariesArray[indexPath.row] as? MonthlySummary
            }
        }
    }

}
