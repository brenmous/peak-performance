//
//  SecondMonthlyReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 8/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip

class SecondMonthlyReviewViewController: UITableViewController {

    // MARK: - Properties 
    
    let dataService = DataService()
    
    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: MonthlySummary?
    
    /// Poptip
    let popTip = AMPopTip()
    
    
    // MARK: - Outlets
    
    // Text views
    @IBOutlet weak var whatIsWorkingTextView: UITextView!
    @IBOutlet weak var whatIsNotWorkingTextView: UITextView!
    @IBOutlet weak var whatHaveIImprovedTextView: UITextView!
    @IBOutlet weak var doIHaveToChangeTextView: UITextView!
    
    // Plot points 
    @IBOutlet weak var familyPoint: UIButton!
    @IBOutlet weak var friendPoint: UIButton!
    @IBOutlet weak var financialPoint: UIButton!
    @IBOutlet weak var healthPoint: UIButton!
    @IBOutlet weak var partnerPoint: UIButton!
    @IBOutlet weak var personalDevelopmentPoint: UIButton!
    @IBOutlet weak var workPoint: UIButton!
    @IBOutlet weak var emotionalSpiritual: UIButton!
    
    // KLA graph
    @IBOutlet weak var klaDiagramPeakPerformanceArea: CustomizableLabelView!

    
    // MARK: - Actions
    
    /// BEN ///
    @IBAction func familyPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Family", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: familyPoint.frame)
        popTip.popoverColor = UIColor.init(red: 32/355, green: 113/255, blue: 201/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()

    }
    
    @IBAction func friendPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Friend", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: friendPoint.frame)
        popTip.popoverColor = UIColor.init(red: 101/355, green: 229/255, blue: 225/255, alpha: 1)
        popTip.textColor = UIColor.blackColor()
    }
    
    @IBAction func healthPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Health", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: healthPoint.frame)
        popTip.popoverColor = UIColor.init(red: 191/355, green: 204/255, blue: 31/255, alpha: 1)
        popTip.textColor = UIColor.blackColor()
        
    }
    
    @IBAction func partnerPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Partner", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: partnerPoint.frame)
        popTip.popoverColor = UIColor.init(red: 193/355, green: 36/255, blue: 198/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    }
    
    @IBAction func financialPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Financial", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: financialPoint.frame)
        popTip.popoverColor = UIColor.init(red: 47/355, green: 188/255, blue: 184/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    }
    
    @IBAction func personalDevelopmentPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Personal Development", direction: .Up, maxWidth: 90, inView: super.view, fromFrame: personalDevelopmentPoint.frame)
        popTip.popoverColor = UIColor.orangeColor()
        popTip.textColor = UIColor.whiteColor()
    }
    
    @IBAction func workPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Work", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: workPoint.frame)
       popTip.popoverColor = UIColor.yellowColor()
        popTip.textColor = UIColor.blackColor()
    }

    @IBAction func emotionalSpiritualPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Emotional/Spiritual", direction: .Up, maxWidth: 90, inView: super.view, fromFrame: emotionalSpiritual.frame)
       popTip.popoverColor = UIColor.init(red: 144/355, green: 85/255, blue: 153/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    }
    /// END BEN ///
    
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        self.updateSummaryWithText()
        guard let s = self.summary else { return }
        guard let cu = self.currentUser else { return }
        s.reviewed = true
        self.dataService.saveSummary(cu, summary: s)
        performSegueWithIdentifier(UNWIND_TO_HISTORY_SEGUE, sender: self)
        
    }
    
    // MARK: - Methods
    
    /// Updates the summary being reviewed with text from the text views.
    func updateSummaryWithText()
    {
        guard let s = self.summary else { return }
        s.whatIsWorking = self.whatIsWorkingTextView.text
        s.whatIsNotWorking = self.whatIsNotWorkingTextView.text
        s.whatHaveIImproved = self.whatHaveIImprovedTextView.text
        s.doIHaveToChange = self.doIHaveToChangeTextView.text
    }
    
    // BEN //
    // Function to diplay the points of 8 key life areas;
    // Derives the origin (0,0) from the midpoint of the parent view and the biggest circle
    func displayPoints( ) {
        
        
        // origin
        let xmidpoint = (self.view.frame.size.width/2) - (familyPoint.frame.size.width/2)
        let ymidpoint = (klaDiagramPeakPerformanceArea.frame.midY) - (familyPoint.frame.size.width/2)
        
        
        // family point
        var familyFrame: CGRect = familyPoint.frame
        familyFrame.origin.x = xmidpoint
        familyFrame.origin.y = ymidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FAMILY]!)
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
        emotionalSpiritual.translatesAutoresizingMaskIntoConstraints = true
        emotionalSpiritual.frame = emotionalSpiritualFrame
    }
    // END BEN //
    
    
    // MARK: - keyboard stuff
    
    /// Work around for dismissing keyboard on text view.
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder( )
            return false
        }
        else
        {
            return true
        }
    }
    
    /// Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        self.view.endEditing(true)
    }
    
        // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPoints( )
        
        // BEN //
        // Poptip
        popTip.offset = -50 // FIXME: Please make constant
        popTip.arrowSize = CGSize(width: 10, height: 10)
        popTip.shouldDismissOnTap = true
        // END BEN //
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
