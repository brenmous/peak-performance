//
//  HistoryViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 6/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import MessageUI
import PDFGenerator // https://github.com/sgr-ksmt/PDFGenerator

class HistoryViewController: UITableViewController, MFMailComposeViewControllerDelegate
{

    // MARK: - Properties
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The currently logged in user.
    var currentUser: User?
    
    /// Table view data source array.
    var summariesArray = [[Summary]]()
    
    /// Summary selected to send to coach.
    var summaryToSend: MonthlySummary?
    
    // MARK: - Outlets

    
    // MARK: - Actions
    @IBAction func menuButtonPressed(_ sender: AnyObject)
    {
        self.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    @IBAction func sendEmailToCoachPressed(_ sender: AnyObject)
    {
        if self.currentUser!.coachEmail.isEmpty
        {
            self.present(getNoCoachEmailAlert(), animated: true, completion: nil)
            return
        }
        
        //get summary to send
        let button = sender as! UIButton
        let cell = button.superview!.superview as! HistoryTableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let summary = self.summariesArray[indexPath!.section][indexPath!.row] as! MonthlySummary
        self.summaryToSend = summary
        self.sendToCoach(summary)
    }
    
    @IBAction func unwindToHistory(_ sender: UIStoryboardSegue){}
    
    
    // MARK: - Methods
    
    /// Delegate function for MFMailComposeViewController. Handles dismissal of mail VC.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
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
    func sendToCoach(_ summary: MonthlySummary)
    {
        print("SENDING TO COACH")
        //set recipient (coach email)
        let mailVC = MFMailComposeViewController( )
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([self.currentUser!.coachEmail])
        print("1")
        
        //get month of selected summary and set as email subject
        let month = Date( ).monthAsString(summary.date)
        let subject = SUMMARY_EMAIL_SUBJECT(month)
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
        mailVC.setMessageBody(SUMMARY_EMAIL_BODY(month, user: self.currentUser!), isHTML: false)
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailVC, animated: true, completion: nil)
        }
    }
    
    /**
        Generates PDFs of the summary selected to email to coach.
        - Returns: An array of PDFs as NSData. Array will be empty if an error occurred.
    */
    func generatePDF( ) -> [Data]
    {
        let junk = [Data()]
        print("UNWRAPPING SBS")
        //Get summary view controllers for creating PDFs from views
        let vcSum = self.storyboard?.instantiateViewController(withIdentifier: HISTORY_SUMMARY_VC) as? SummaryViewController
        guard let vcs = vcSum else { print("VCSUM IS NIL"); return junk }
        vcs.summary = self.summaryToSend
        vcs.tableView!.reloadData()
 
        let vcGoals = self.storyboard?.instantiateViewController(withIdentifier: HISTORY_GOALS_VC) as? SecondSummaryViewController
        guard let vcg = vcGoals else { print("VCGOALS IS NIL"); return junk }
        vcg.summary = self.summaryToSend
        vcg.tableView!.reloadData()
        while(vcs.viewIfLoaded == nil && vcg.viewIfLoaded == nil){} //wait for views to load
        print("FINISHED UNWRAP")
        
        var pdfs = [Data]( )
        do
        {
            let pdfSum = try PDFGenerator.generated(by: vcs.view)
            let pdfGoals = try PDFGenerator.generated(by: vcg.view)
            pdfs.insert(pdfSum, at: 0); pdfs.insert(pdfGoals, at: 1)
        }
        catch (let error)
        {
            print("HVC - generatePDF(): \(error)")
        }
        return pdfs
    }
    
    /// Orders the nested data source array so that goals are displayed in yearly sections.
    func setUpSummaryArray()
    {
        summariesArray = [[Summary]](repeating: [Summary](), count: currentUser!.year+1)
        var offsetForCheckDates = currentUser!.year
        for year in 0...currentUser!.year
        {

            let calendar = Calendar.current
            let checkDateStart = (calendar as NSCalendar).date(byAdding: .year, value: year, to: currentUser!.startDate as Date, options: [])
            let checkDateEnd = (calendar as NSCalendar).date(byAdding: .year, value: year + 1, to: currentUser!.startDate as Date, options: [])
            offsetForCheckDates += 1
            for (_, val) in self.currentUser!.monthlySummaries
            {
                if val != nil && (val?.date.compare(checkDateStart!) == .orderedDescending || val?.date.compare(checkDateStart!) == .orderedSame) && val?.date.compare(checkDateEnd!) == .orderedAscending
                {
                    self.summariesArray[year].append(val!)
                }
            }
            
            //sort monthly summaries by date with newest first
            if summariesArray[year].count > 1
            {
                self.summariesArray[year].sort(by: {($0 as! MonthlySummary).date.compare(($1 as! MonthlySummary).date as Date) == .orderedDescending })
            }
            
            if year == 0 { summariesArray[0].append(currentUser!.initialSummary) }

            //handle yearly summaries
            if let yearlySummary = self.currentUser!.yearlySummary[year]
            {
                guard let ys = yearlySummary else { continue }
                self.summariesArray[year].insert(ys, at: 0)
            }
        }
        //reverse array to place most recent years first
        summariesArray = summariesArray.reversed()
    }
    
    
    // MARK: - Overridden methods
    
    override func viewWillAppear(_ animated: Bool)
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
        let noCoachEmailAlertController = UIAlertController(title: NO_COACH_EMAIL_ALERT_TITLE, message: NO_COACH_EMAIL_ALERT_MSG, preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: NO_COACH_EMAIL_ALERT_CONFIRM, style: .default, handler: nil)
        
        noCoachEmailAlertController.addAction(confirm)
        
        return noCoachEmailAlertController
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return currentUser!.year > 0 ? currentUser!.year + 1 : 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Year \(summariesArray.count - section)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return summariesArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> HistoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        let s = summariesArray[indexPath.section][indexPath.row]

        if s is MonthlySummary
        {
            let summary = s as! MonthlySummary
            //set month label
            let dateFormatter = DateFormatter( )
            dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
            let dateAsString = dateFormatter.string(from: summary.date as Date)
            cell.monthLabel.text = dateAsString
            
            //send to coach button
            if !summary.sent && summary.reviewed
            {
                cell.sendToCoachButton.isHidden = false
                cell.sendToCoachImage.isHidden = false
            }
            else
            {
                cell.sendToCoachButton.isHidden = true
                cell.sendToCoachImage.isHidden = true
            }
            
            //set "review ready" label
            if !summary.reviewed
            {
                cell.reviewReadyLabel.text = SUMMARY_CELL_REVIEW_READY
                cell.reviewReadyLabel.textColor = UIColor.init(red: 143/255, green: 87/255, blue: 152/255, alpha: 1)
            }
            else
            {
                cell.reviewReadyLabel.text = SUMMARY_CELL_REVIEW_COMPLETE
                cell.reviewReadyLabel.textColor = UIColor.gray
            }
        }
        else if s is CurrentRealitySummary
        {
            //let summary = s as! CurrentRealitySummary
            cell.sendToCoachButton.isHidden = true
            cell.sendToCoachImage.isHidden = true
            cell.reviewReadyLabel.text = SUMMARY_CELL_VIEW_INITIAL_REVIEW
            cell.monthLabel.text = SUMMARY_CELL_INITIAL_REVIEW
            cell.reviewReadyLabel.textColor = UIColor.gray
        }
        else if s is YearlySummary
        {
            let summary = s as! YearlySummary
            cell.sendToCoachButton.isHidden = true
            cell.sendToCoachImage.isHidden = true
            cell.monthLabel.text = SUMMARY_CELL_YEARLY_REVIEW
            
            if !summary.reviewed
            {
                cell.reviewReadyLabel.text = SUMMARY_CELL_REVIEW_READY
                cell.reviewReadyLabel.textColor = UIColor.init(red: 143/255, green: 87/255, blue: 152/255, alpha: 1)
            }
            else
            {
                cell.reviewReadyLabel.text = SUMMARY_CELL_REVIEW_COMPLETE
                cell.reviewReadyLabel.textColor = UIColor.gray
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let s = summariesArray[indexPath.section][indexPath.row]
        
        if s is MonthlySummary
        {
            let summary = s as! MonthlySummary
            
            //determine selected cell and perform associated action.
            if summary.reviewed == false
            {
                //go to review for summary
                performSegue(withIdentifier: GO_TO_REVIEW_SEGUE, sender: self)
                return
            }
            else
            {
                performSegue(withIdentifier: GO_TO_SUMMARY_SEGUE, sender: self)
                return
            }
        }
        else if s is YearlySummary
        {
            performSegue(withIdentifier: GO_TO_YEARLY_REVIEW_SEGUE, sender: self)
            return
        }
        else if s is CurrentRealitySummary
        {
            performSegue(withIdentifier: GO_TO_INITIAL_REVIEW_SEGUE, sender: self)
            return
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier!
        {
        case GO_TO_REVIEW_SEGUE:
            let dvc = segue.destination as! MonthlyReviewViewController
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = summariesArray[indexPath.section][indexPath.row] as? MonthlySummary
            }
                
        case GO_TO_SUMMARY_SEGUE:
            let dvc = segue.destination as! SummaryViewController
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = summariesArray[indexPath.section][indexPath.row] as? MonthlySummary
            }
        
        case GO_TO_YEARLY_REVIEW_SEGUE:
            let dvc = segue.destination as! YearReviewViewController
            dvc.currentUser = self.currentUser
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                dvc.summary = summariesArray[indexPath.section][indexPath.row] as? YearlySummary
            }
            
        case GO_TO_INITIAL_REVIEW_SEGUE:
            let dvc = segue.destination as! InitialReviewSummaryTableViewController
            dvc.currentUser = self.currentUser
            dvc.summary = self.currentUser?.initialSummary
            
        default:
            return
        }
    }

}
