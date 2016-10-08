//
//  SummaryViewController.swift
//  PeakPerformance
//
//  Created by Bren on 12/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip


class SummaryViewController: UITableViewController {

    // MARK: - Properties
    
    var summary: MonthlySummary?
  
    let familyPopTip = AMPopTip()
    let healthPopTip = AMPopTip()
    let workPopTip = AMPopTip()
    let friendPopTip = AMPopTip()
    let emotionalSpiritualPopTip = AMPopTip()
    let personalDevPopTip = AMPopTip()
    let partnerPopTip = AMPopTip()
    let financialPopTip = AMPopTip()
    
    // MARK: - Outlets
    
    /// KLA points
    
    @IBOutlet weak var personalDevelopmentPoint: UIButton!
    
    @IBOutlet weak var financialPoint: UIButton!
    
    @IBOutlet weak var partnerPoint: UIButton!

    @IBOutlet weak var emotionalSpiritualPoint: UIButton!
    
    @IBOutlet weak var workPoint: UIButton!
    
    @IBOutlet weak var healthPoint: UIButton!
    
    @IBOutlet weak var friendPoint: UIButton!
    
    @IBOutlet weak var familyPoint: UIButton!
    
    /// KLA Diagram
    @IBOutlet weak var klaDiagramPeakPerformanceArea: CustomizableLabelView!
    
    // MARK: - Actions
    
    /// KLA Buttons
    
    @IBAction func personalDevelopmentPointPressed(sender: AnyObject) {

    }
    
    @IBAction func financialPointPressed(sender: AnyObject) {
        
    }
    
    @IBAction func partnerPointPressed(sender: AnyObject) {

    }

    @IBAction func emotionalSpiritualPointPressed(sender: AnyObject) {

    }
    
    @IBAction func workPointPressed(sender: AnyObject) {

    }
    
    @IBAction func healthPointPressed(sender: AnyObject) {

    }
   
    @IBAction func friendPointPressed(sender: AnyObject) {
    
    }
    
    @IBAction func familyPointPressed(sender: AnyObject) {

    }

    
    // Review Questions
    @IBOutlet weak var whatIsWorkingTextView: UITextView!
    
    @IBOutlet weak var whatIsNotWorkingTextView: UITextView!

    @IBOutlet weak var whatHaveIImprovedTextView: UITextView!

    @IBOutlet weak var doINeedToChangeTextView: UITextView!
    
    // MARK: - Actions
    @IBAction func weeklyButtonPressed(sender: AnyObject)
    {
        performSegueWithIdentifier(GO_TO_SECOND_SUMMARY_SEGUE, sender: self)
    }
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateTextViews( )
        
        displayPoints( )
        displayPopTips( )

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    /// Update the text views with the strings from the summary.
    func updateTextViews( )
    {
        //TODO: maybe have some sort of placeholder "nothing was entered for this section" or prevent user from leaving these sections blank in the review
        guard let s = self.summary else
        {
            print("SVC: problem getting summary")
            return
        }
        self.whatIsWorkingTextView.text = s.whatIsWorking
        self.whatIsNotWorkingTextView.text = s.whatIsNotWorking
        self.whatHaveIImprovedTextView.text = s.whatHaveIImproved
        self.doINeedToChangeTextView.text = s.doIHaveToChange
    }

    func displayPoints( ) {
        
        
        // origin
        let xmidpoint = (self.view.frame.size.width/2) - (familyPoint.frame.size.width/2)
        let ymidpoint = (klaDiagramPeakPerformanceArea.frame.midY) - (familyPoint.frame.size.width/2)
        
        
        // family point
        var familyFrame: CGRect = familyPoint.frame
        familyFrame.origin.x = xmidpoint
        familyFrame.origin.y = ymidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FAMILY]!)
        print("coord y \(familyFrame.origin.y)")
        print("family y coord\(familyFrame.origin.y)")
        familyPoint.translatesAutoresizingMaskIntoConstraints = true
        familyPoint.frame = familyFrame
        
        // financial point
        var financialFrame: CGRect = financialPoint.frame
        financialFrame.origin.x = xmidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FINANCIAL]!)
        financialFrame.origin.y = ymidpoint
        financialPoint.translatesAutoresizingMaskIntoConstraints = true
        financialPoint.frame = financialFrame
        
        // friend point
        var friendFrame: CGRect = friendPoint.frame
        friendFrame.origin.x = xmidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FRIENDSSOCIAL]!))
        friendFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FRIENDSSOCIAL]!))
        friendPoint.translatesAutoresizingMaskIntoConstraints = true
        friendPoint.frame = friendFrame
        
        // health point
        var healthFrame: CGRect = healthPoint.frame
        healthFrame.origin.x = xmidpoint
        healthFrame.origin.y = ymidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_HEALTHFITNESS]!)
        healthPoint.translatesAutoresizingMaskIntoConstraints = true
        healthPoint.frame = healthFrame
        
        // partner point
        var partnerFrame: CGRect = partnerPoint.frame
        partnerFrame.origin.x = xmidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PARTNER]!)
        partnerFrame.origin.y = ymidpoint
        partnerPoint.translatesAutoresizingMaskIntoConstraints = true
        partnerPoint.frame = partnerFrame
        
        
        // personal development point
        var personalDevelopmentFrame: CGRect = personalDevelopmentPoint.frame
        personalDevelopmentFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevelopmentFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevelopmentPoint.translatesAutoresizingMaskIntoConstraints = true
        personalDevelopmentPoint.frame = personalDevelopmentFrame
        
        
        // work point
        var workFrame: CGRect = workPoint.frame
        workFrame.origin.x = xmidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_WORKBUSINESS]!))
        workFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_WORKBUSINESS]!))
        workPoint.translatesAutoresizingMaskIntoConstraints = true
        workPoint.frame = workFrame
        
        
        // emotional spiritual point
        var emotionalSpiritualFrame: CGRect = workPoint.frame
        emotionalSpiritualFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualPoint.translatesAutoresizingMaskIntoConstraints = true
        emotionalSpiritualPoint.frame = emotionalSpiritualFrame
        
        
    }
    
    func displayPopTips( ) {
    
        // Display poptips as summary
        
        // Poptips
        familyPopTip.offset = -50
        familyPopTip.arrowSize = CGSize(width: 10, height: 10)
        familyPopTip.shouldDismissOnTapOutside = false
        
        healthPopTip.offset = -50
        healthPopTip.arrowSize = CGSize(width: 10, height: 10)
        healthPopTip.shouldDismissOnTapOutside = false
        
        partnerPopTip.offset = -50
        partnerPopTip.arrowSize = CGSize(width: 10, height: 10)
        partnerPopTip.shouldDismissOnTapOutside = false
        
        friendPopTip.offset = -50
        friendPopTip.arrowSize = CGSize(width: 10, height: 10)
        friendPopTip.shouldDismissOnTapOutside = false
        
        workPopTip.offset = -50
        workPopTip.arrowSize = CGSize(width: 10, height: 10)
        workPopTip.shouldDismissOnTapOutside = false
        
        personalDevPopTip.offset = -50
        personalDevPopTip.arrowSize = CGSize(width: 10, height: 10)
        personalDevPopTip.shouldDismissOnTapOutside = false
        
        emotionalSpiritualPopTip.offset = -50
        emotionalSpiritualPopTip.arrowSize = CGSize(width: 10, height: 10)
        emotionalSpiritualPopTip.shouldDismissOnTapOutside = false
        
        financialPopTip.offset = -50
        financialPopTip.arrowSize = CGSize(width: 10, height: 10)
        financialPopTip.shouldDismissOnTapOutside = false
        /// family
        familyPopTip.showText("Family", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: familyPoint.frame)
        familyPopTip.popoverColor = UIColor.init(red: 32/355, green: 113/255, blue: 201/255, alpha: 1)
        familyPopTip.textColor = UIColor.whiteColor()

        /// friend
        friendPopTip.showText("Friend", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: friendPoint.frame)
        friendPopTip.popoverColor = UIColor.init(red: 101/355, green: 229/255, blue: 225/255, alpha: 1)
        friendPopTip.textColor = UIColor.blackColor()
        
        /// Health
        healthPopTip.showText("Health", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: healthPoint.frame)
        healthPopTip.popoverColor = UIColor.init(red: 191/355, green: 204/255, blue: 31/255, alpha: 1)
        healthPopTip.textColor = UIColor.blackColor()
        
        /// Partner
        partnerPopTip.showText("Partner", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: partnerPoint.frame)
        partnerPopTip.popoverColor = UIColor.init(red: 193/355, green: 36/255, blue: 198/255, alpha: 1)
        partnerPopTip.textColor = UIColor.whiteColor()
        
        /// Financial
        financialPopTip.showText("Financial", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: financialPoint.frame)
        financialPopTip.popoverColor = UIColor.init(red: 47/355, green: 188/255, blue: 184/255, alpha: 1)
        financialPopTip.textColor = UIColor.whiteColor()
        
        
        /// Personal Development
        personalDevPopTip.showText("Personal Development", direction: .Up, maxWidth: 90, inView: super.view, fromFrame: personalDevelopmentPoint.frame)
        personalDevPopTip.popoverColor = UIColor.orangeColor()
        personalDevPopTip.textColor = UIColor.whiteColor()
        
        
        /// Work
        workPopTip.showText("Work", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: workPoint.frame)
        workPopTip.popoverColor = UIColor.yellowColor()
        workPopTip.textColor = UIColor.blackColor()
        
        
        /// Emotional/Spritual
        emotionalSpiritualPopTip.showText("Emotional/Spiritual", direction: .Up, maxWidth: 90, inView: super.view, fromFrame: emotionalSpiritualPoint.frame)
        emotionalSpiritualPopTip.popoverColor = UIColor.init(red: 144/355, green: 85/255, blue: 153/255, alpha: 1)
        emotionalSpiritualPopTip.textColor = UIColor.whiteColor()
    
    
    }
    
    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == GO_TO_SECOND_SUMMARY_SEGUE
        {
            let dvc = segue.destinationViewController as! SecondSummaryViewController
            dvc.summary = self.summary
        }
        
    }
    

}
