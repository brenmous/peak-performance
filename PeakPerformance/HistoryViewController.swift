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
import PDFGenerator // github.com/sgr-ksmt/PDFGenerator

class HistoryViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Properties
    
    let dataService = DataService()
    
    /// The currently logged in user.
    var currentUser: User?
    
    /// Table view data source array.
    var monthlySummariesArray = [Summary]( )
    
    /// Summary selected to send to coach.
    var summaryToSend: MonthlySummary?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func menuButtonPressed(sender: AnyObject) {
        self.presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func cellDidLongPress(sender: AnyObject) {
        print("long pressed")
    }
    
    @IBAction func sendEmailToCoachPressed(sender: AnyObject )
    {
        if self.currentUser!.coachEmail.isEmpty
        {
            self.presentViewController(getNoCoachEmailAlert(), animated: true, completion: nil)
            return
        }
        
        //get summary to send
        let button = sender as! UIButton
        let cell = button.superview!.superview as! HistoryTableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let summary = self.monthlySummariesArray[indexPath!.row] as! MonthlySummary
        self.summaryToSend = summary
        self.sendToCoach(summary)
    }
    
    @IBAction func unwindToHistory(sender: UIStoryboardSegue){}
    
    // MARK: - Methods
    
    /// Delegate function for MFMailComposeViewController. Handles dismissal of mail VC.
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch result.rawValue
        {
        case 0: //cancelled 
            print("HVC - mailComposeController(): cancelled")
            
        case 1: //saved as draft
            print("HVC: - mailComposeController(): saved as draft")
        
        case 2: //sent
            print("HVC: - mailComposeController(): queued to send")
            self.summaryToSend!.sent = true
            self.dataService.saveSummary(self.currentUser!, summary: self.summaryToSend!)
            self.summaryToSend = nil
            self.tableView!.reloadData( )
            
        case 3: //failed
            print("HVC - mailComposeController(): send failed with error \(error?.localizedDescription)")
        
        default: //unknown
            print("HVC - mailComposeController(): unknown result, this is Apple's problem")
        }
    }
    
    /**
        Sends specified summary to coach.
        - Parameters:
            - summary: the summary to send.
    */
    func sendToCoach(summary: MonthlySummary)
    {
        //set recipient (coach email)
        let mailVC = MFMailComposeViewController( )
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([self.currentUser!.coachEmail])
        
        //get month of selected summary and set as email subject
        let month = NSDate( ).monthAsString(summary.date)
        let subject = "My monthly review for \(month)." //TODO: make constant
        mailVC.setSubject(subject)
        
        //attach monthly summary PDFs
        let pdfs = self.generatePDF()
        if pdfs.count < 2
        {
            print("HVC - sendEmailToCoachPressed(): error getting PDFs")
        }
        mailVC.addAttachmentData(pdfs[0], mimeType: PDF_MIME_TYPE, fileName: "\(currentUser!.email)_\(month)_summary.pdf")
        mailVC.addAttachmentData(pdfs[1], mimeType: PDF_MIME_TYPE, fileName: "\(currentUser!.email)_\(month)_goals.pdf")
        
        //set email body
        mailVC.setMessageBody("\(self.currentUser!.email)\n\(self.currentUser!.uid)", isHTML: false)
        
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
    
    /**
        Generates PDFs of the summary selected to email to coach.
        - Returns: An array of PDFs as NSData. Array will be empty if an error occurred.
    */
    func generatePDF( ) -> [NSData]
    {
        //Get summary view controllers for creating PDFs from views
        print("HVC - generatePDF(): getting summary view")
        let vcSum = self.storyboard?.instantiateViewControllerWithIdentifier(HISTORY_SUMMARY_VC) as! SummaryViewController
        vcSum.summary = self.summaryToSend
        vcSum.tableView!.reloadData()
        
         print("HVC - generatePDF(): getting goal view")
        let vcGoals = self.storyboard?.instantiateViewControllerWithIdentifier(HISTORY_GOALS_VC) as! SecondSummaryViewController
        vcGoals.summary = self.summaryToSend
        vcGoals.tableView!.reloadData()
        while(vcSum.viewIfLoaded == nil && vcGoals.viewIfLoaded == nil){} //wait for views to load
     
        var pdfs = [NSData]( )
        print("HVC - generatePDF(): attemping to generate PDFs")
        do
        {
            let pdfSum = try PDFGenerator.generate(vcSum.view)
            let pdfGoals = try PDFGenerator.generate(vcGoals.view)
            pdfs.insert(pdfSum, atIndex: 0); pdfs.insert(pdfGoals, atIndex: 1)
            print("HVC - generatePDF(): PDFs generated")
        }
        catch (let error)
        {
            //handle error
            print("HVC - generatePDF(): \(error)")
        }
        return pdfs
    }
    
    func setUpSummaryArray()
    {
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
        
        //sort monthly summaries by date with newest first
        self.monthlySummariesArray.sortInPlace({($0 as! MonthlySummary).date.compare(($1 as! MonthlySummary).date) == .OrderedDescending })
        
        //handle once a year summaries
        if let yearlySummary = self.currentUser?.yearlySummary
        {
            if yearlySummary is CurrentRealitySummary { self.monthlySummariesArray.append(yearlySummary) } //place initial review at bottom of table
            
            if yearlySummary is YearlySummary
            {
                let ys = yearlySummary as! YearlySummary
                if !ys.reviewed { self.monthlySummariesArray.insert(self.currentUser!.yearlySummary!, atIndex: 0) } //place unreviewed annual review at top of table
                if ys.reviewed { self.monthlySummariesArray.append(yearlySummary) } //place reviewed annual review at bottom of table
            }
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
        
        self.titleLabel.text = "Goal Summary for Year \(self.currentUser!.year + 1)"
        
        //check if a yearly review is needed
        if self.currentUser!.checkYearlyReview()
        {
            //inform user review is needed
            self.currentUser!.allMonthlyReviewsFromLastYear()
        }
            //only check for monthly reviews if the year hasn't changed, because if it has we know we need 12 months of reviews
        else
        {
            //check if a monthly review is needed
            if self.currentUser!.checkMonthlyReview()
            {
                //self.presentViewController(UIAlertController.getReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
            }
        }
        
        self.setUpSummaryArray()
        
        //set up side menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: currentUser! ) //func declaration is in SideMenuViewController
        
        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        self.tableView.reloadData( )
    }
    
  
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
 

    // MARK: - Alert controllers
    /**
     Creates an alert informing user that mail can't be sent because no coach email has been supplied.
     - Parameters:
     - hvc: the History view controller.
     
     - Returns: an alert controller
     */
    func getNoCoachEmailAlert() -> UIAlertController
    {
        let noCoachEmailAlertController = UIAlertController(title: NO_COACH_EMAIL_ALERT_TITLE, message: NO_COACH_EMAIL_ALERT_MSG, preferredStyle: .ActionSheet)
        let confirm = UIAlertAction(title: NO_COACH_EMAIL_ALERT_CONFIRM, style: .Default, handler: nil)
        
        noCoachEmailAlertController.addAction(confirm)
        
        return noCoachEmailAlertController
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
            let dateAsString = dateFormatter.stringFromDate(summary.date)
            cell.monthLabel.text = dateAsString
            
            //send to coach button
            if !summary.sent && summary.reviewed
            {
                cell.sendToCoachButton.hidden = false
            }
            else
            {
                cell.sendToCoachButton.hidden = true
            }
            
            //set "review ready" label
            if !summary.reviewed
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
        else if s is YearlySummary
        {
            let summary = s as! YearlySummary
            cell.sendToCoachButton.hidden = true
            cell.monthLabel.text = "Yearly Review"
            
            if !summary.reviewed
            {
                cell.reviewReadyLabel.text = "Review ready to complete!"
                cell.reviewReadyLabel.textColor = UIColor.init(red: 143/255, green: 87/255, blue: 152/255, alpha: 1)
            }
            else
            {
                cell.reviewReadyLabel.text = "Review complete - view summary"
                cell.reviewReadyLabel.textColor = UIColor.grayColor()
            }
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
                return
            }
        }
        else if s is YearlySummary
        {
            performSegueWithIdentifier(GO_TO_YEARLY_REVIEW_SEGUE, sender: self)
            return
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
        switch segue.identifier!
        {
        case GO_TO_REVIEW_SEGUE:
            print("HVC: going to review view")
            let dvc = segue.destinationViewController as! MonthlyReviewViewController
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = self.monthlySummariesArray[indexPath.row] as? MonthlySummary
            }
                
        case GO_TO_SUMMARY_SEGUE:
            print("HVC: going to summary view")
            let dvc = segue.destinationViewController as! SummaryViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = self.monthlySummariesArray[indexPath.row] as? MonthlySummary
            }
        
        case GO_TO_YEARLY_REVIEW_SEGUE:
            let dvc = segue.destinationViewController as! YearReviewViewController
            dvc.currentUser = self.currentUser
            
        default:
            return
        }
    }

}
