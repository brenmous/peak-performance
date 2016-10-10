//
//  SummaryViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 12/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip


class SummaryViewController: UITableViewController {

    // MARK: - Properties
    
    var summary: MonthlySummary?
  
    // BEN //
    let familyPopTip = AMPopTip()
    let healthPopTip = AMPopTip()
    let workPopTip = AMPopTip()
    let friendPopTip = AMPopTip()
    let emotionalSpiritualPopTip = AMPopTip()
    let personalDevPopTip = AMPopTip()
    let partnerPopTip = AMPopTip()
    let financialPopTip = AMPopTip()
    // END BEN //
    
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
    
    // Text views
    @IBOutlet weak var whatIsWorkingTextView: UITextView!
    
    @IBOutlet weak var whatIsNotWorkingTextView: UITextView!

    @IBOutlet weak var whatHaveIImprovedTextView: UITextView!

    @IBOutlet weak var doINeedToChangeTextView: UITextView!
    
    
    // MARK: - Actions
    
    //BEN//
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
    // END BEN //
    
    @IBAction func weeklyButtonPressed(sender: AnyObject)
    {
        performSegueWithIdentifier(GO_TO_SECOND_SUMMARY_SEGUE, sender: self)
    }
    
    
    // MARK: - Methods
    
    /// Update the text views with the strings from the summary.
    func updateTextViews( )
    {
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

    // FIXME: Please comment and turn raw values into constants
    // BEN //
    func displayPoints( ) {
        
        
        /// origin
        let xmidpoint = (self.view.frame.size.width/2) - (familyPoint.frame.size.width/2)
        let ymidpoint = (klaDiagramPeakPerformanceArea.frame.midY) - (familyPoint.frame.size.width/2)
        
        
        /// family point
        var familyFrame: CGRect = familyPoint.frame
        familyFrame.origin.x = xmidpoint
        familyFrame.origin.y = ymidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FAMILY]!)
        print("coord y \(familyFrame.origin.y)")
        print("family y coord\(familyFrame.origin.y)")
        familyPoint.translatesAutoresizingMaskIntoConstraints = true
        familyPoint.frame = familyFrame
        
        /// financial point
        var financialFrame: CGRect = financialPoint.frame
        financialFrame.origin.x = xmidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FINANCIAL]!)
        financialFrame.origin.y = ymidpoint
        financialPoint.translatesAutoresizingMaskIntoConstraints = true
        financialPoint.frame = financialFrame
        
        /// friend point
        var friendFrame: CGRect = friendPoint.frame
        friendFrame.origin.x = xmidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FRIENDSSOCIAL]!))
        friendFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FRIENDSSOCIAL]!))
        friendPoint.translatesAutoresizingMaskIntoConstraints = true
        friendPoint.frame = friendFrame
        
        /// health point
        var healthFrame: CGRect = healthPoint.frame
        healthFrame.origin.x = xmidpoint
        healthFrame.origin.y = ymidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_HEALTHFITNESS]!)
        healthPoint.translatesAutoresizingMaskIntoConstraints = true
        healthPoint.frame = healthFrame
        
        /// partner point
        var partnerFrame: CGRect = partnerPoint.frame
        partnerFrame.origin.x = xmidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PARTNER]!)
        partnerFrame.origin.y = ymidpoint
        partnerPoint.translatesAutoresizingMaskIntoConstraints = true
        partnerPoint.frame = partnerFrame
        
        
        /// personal development point
        var personalDevelopmentFrame: CGRect = personalDevelopmentPoint.frame
        personalDevelopmentFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevelopmentFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevelopmentPoint.translatesAutoresizingMaskIntoConstraints = true
        personalDevelopmentPoint.frame = personalDevelopmentFrame
        
        
        /// work point
        var workFrame: CGRect = workPoint.frame
        workFrame.origin.x = xmidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_WORKBUSINESS]!))
        workFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_WORKBUSINESS]!))
        workPoint.translatesAutoresizingMaskIntoConstraints = true
        workPoint.frame = workFrame
        
        
        /// emotional spiritual point
        var emotionalSpiritualFrame: CGRect = workPoint.frame
        emotionalSpiritualFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualPoint.translatesAutoresizingMaskIntoConstraints = true
        emotionalSpiritualPoint.frame = emotionalSpiritualFrame
        
        
    }
    

    func displayPopTips( ) {
        
        /// family
        familyPopTip.offset = POPTIP_OFFSET
        familyPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        familyPopTip.shouldDismissOnTapOutside = false
        familyPopTip.showText(KLA_FAMILY, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: familyPoint.frame)
        familyPopTip.popoverColor = PEAK_FAMILY_BLUE
        familyPopTip.textColor = UIColor.whiteColor()

        /// friend
        friendPopTip.offset = POPTIP_OFFSET
        friendPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        friendPopTip.shouldDismissOnTapOutside = false
        friendPopTip.showText(KLA_FRIENDSSOCIAL, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: friendPoint.frame)
        friendPopTip.popoverColor = PEAK_FRIEND_CYAN
        friendPopTip.textColor = UIColor.blackColor()
        
        /// Health
        healthPopTip.offset = POPTIP_OFFSET
        healthPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        healthPopTip.shouldDismissOnTapOutside = false
        healthPopTip.showText(KLA_HEALTHFITNESS, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: healthPoint.frame)
        healthPopTip.popoverColor = PEAK_HEALTH_GREEN
        healthPopTip.textColor = UIColor.blackColor()

        
        /// Partner
        partnerPopTip.offset = POPTIP_OFFSET
        partnerPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        partnerPopTip.shouldDismissOnTapOutside = false
        partnerPopTip.showText(KLA_PARTNER, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: partnerPoint.frame)
        partnerPopTip.popoverColor = PEAK_PARTNER_PURPLE
        partnerPopTip.textColor = UIColor.whiteColor()

        
        /// Financial
        financialPopTip.offset = POPTIP_OFFSET
        financialPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        financialPopTip.shouldDismissOnTapOutside = false
        financialPopTip.showText(KLA_FINANCIAL, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: financialPoint.frame)
        financialPopTip.popoverColor = PEAK_FINANCE_BLUE_GREEN
        financialPopTip.textColor = UIColor.whiteColor()

        
        /// Personal Development
        personalDevPopTip.offset = POPTIP_OFFSET
        personalDevPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        personalDevPopTip.shouldDismissOnTapOutside = false
        personalDevPopTip.showText(KLA_PERSONALDEV, direction: .Up, maxWidth: POPTIP_MAXWIDTH + 30, inView: super.view, fromFrame: personalDevelopmentPoint.frame)
        personalDevPopTip.popoverColor = UIColor.orangeColor()
        personalDevPopTip.textColor = UIColor.whiteColor()

        
        /// Work
        workPopTip.offset = POPTIP_OFFSET
        workPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        workPopTip.shouldDismissOnTapOutside = false
        workPopTip.showText(KLA_WORKBUSINESS, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: workPoint.frame)
        workPopTip.popoverColor = UIColor.yellowColor()
        workPopTip.textColor = UIColor.blackColor()

        
        /// Emotional/Spritual
        emotionalSpiritualPopTip.offset = POPTIP_OFFSET
        emotionalSpiritualPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        emotionalSpiritualPopTip.shouldDismissOnTapOutside = false
        emotionalSpiritualPopTip.showText(KLA_EMOSPIRITUAL, direction: .Up, maxWidth: POPTIP_MAXWIDTH+30, inView: super.view, fromFrame: emotionalSpiritualPoint.frame)
        emotionalSpiritualPopTip.popoverColor = PEAK_EMOTIONAL_VIOLET
        emotionalSpiritualPopTip.textColor = UIColor.whiteColor()

    }
    
    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = PEAK_NAV_BAR_COLOR
        
        self.updateTextViews( )
        
        displayPoints( )
        displayPopTips( )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
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
