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
        var emotionalSpiritualFrame: CGRect = emotionalSpiritualPoint.frame
        emotionalSpiritualFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualPoint.translatesAutoresizingMaskIntoConstraints = true
        emotionalSpiritualPoint.frame = emotionalSpiritualFrame
        
        
    }
    

    func displayPopTips( ) {

        /// Health
        healthPopTip.offset = POPTIP_OFFSET
        healthPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 30)
        healthPopTip.shouldDismissOnTapOutside = false
        healthPopTip.showText("Health", direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: healthPoint.frame)
        healthPopTip.popoverColor = PEAK_HEALTH_GREEN
        healthPopTip.textColor = UIColor.whiteColor()

        /// Work
        workPopTip.offset = POPTIP_OFFSET
        workPopTip.bubbleOffset = 10
        workPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 15)
        workPopTip.shouldDismissOnTapOutside = false
        workPopTip.showText("Work", direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: workPoint.frame)
        workPopTip.popoverColor = PEAK_WORK_YELLOW
        workPopTip.textColor = UIColor.whiteColor()

        /// Personal Development
        personalDevPopTip.offset = POPTIP_OFFSET
        personalDevPopTip.bubbleOffset = -35
        personalDevPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 15)
        personalDevPopTip.shouldDismissOnTapOutside = false
        personalDevPopTip.showText("Personal Dev't", direction: .Up, maxWidth: POPTIP_MAXWIDTH + 60, inView: super.view, fromFrame: personalDevelopmentPoint.frame)
        personalDevPopTip.popoverColor = PEAK_PERSONAL_ORANGE
        personalDevPopTip.textColor = UIColor.whiteColor()
        

        /// Partner
        let customPartnerView = UIView(frame: CGRect(x: partnerPoint.frame.origin.x + POPTIP_OFFSET + 3, y: partnerPoint.frame.origin.y - POPTIP_OFFSET + 3, width: 65, height: 15))
        let customPartnerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width, height: 15))
        customPartnerLabel.numberOfLines = 1
        //customPartnerLabel.textAlignment = NSTextAlignment.Center
        customPartnerLabel.text = "Partner"
        customPartnerLabel.textColor = UIColor.whiteColor()
        customPartnerLabel.font = UIFont.systemFontOfSize(14)
        customPartnerView.addSubview(customPartnerLabel)
        partnerPopTip.showCustomView(customPartnerView, direction: .Right, inView: self.view, fromFrame: customPartnerView.frame)
       // partnerPopTip.offset = abs(POPTIP_OFFSET)
        //partnerPopTip.bubbleOffset = -50
        partnerPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH , height: POPTIP_ARROW_HEIGHT + 15)
        partnerPopTip.shouldDismissOnTapOutside = false
        //partnerPopTip.showText(KLA_PARTNER, direction: .Down, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: partnerPoint.frame)
        partnerPopTip.popoverColor = PEAK_PARTNER_PURPLE
        partnerPopTip.textColor = UIColor.whiteColor()

        
        /// Financial
        let customFinancialView = UIView(frame: CGRect(x: financialPoint.frame.origin.x, y: partnerPoint.frame.origin.y - POPTIP_OFFSET + 3, width: 75, height: 15))
        let customFinancialLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 15))
        customFinancialLabel.numberOfLines = 1
        //customPartnerLabel.textAlignment = NSTextAlignment.Center
        customFinancialLabel.text = "Financial"
        customFinancialLabel.textColor = UIColor.whiteColor()
        customFinancialLabel.font = UIFont.systemFontOfSize(14)
        customFinancialView.addSubview(customFinancialLabel)
        financialPopTip.showCustomView(customFinancialView, direction: .Left, inView: self.view, fromFrame: customFinancialView.frame)

        //financialPopTip.offset = POPTIP_OFFSET
        financialPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 15)
        financialPopTip.shouldDismissOnTapOutside = false
        //financialPopTip.showText(KLA_FINANCIAL, direction: .Up, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: financialPoint.frame)
        financialPopTip.popoverColor = PEAK_FINANCE_BLUE_GREEN
        //financialPopTip.textColor = UIColor.whiteColor()
        
        /// Emotional/Spritual
        emotionalSpiritualPopTip.offset = abs(POPTIP_OFFSET)
        emotionalSpiritualPopTip.bubbleOffset = -35
        emotionalSpiritualPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 15)
        emotionalSpiritualPopTip.shouldDismissOnTapOutside = false
        emotionalSpiritualPopTip.showText("Emo/Spiritual", direction: .Down, maxWidth: POPTIP_MAXWIDTH+60, inView: super.view, fromFrame: emotionalSpiritualPoint.frame)
        emotionalSpiritualPopTip.popoverColor = PEAK_EMOTIONAL_VIOLET
        emotionalSpiritualPopTip.textColor = UIColor.whiteColor()
        
        /// family
        familyPopTip.offset = abs(POPTIP_OFFSET)
        familyPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 25)
        familyPopTip.shouldDismissOnTapOutside = false
        familyPopTip.showText(KLA_FAMILY, direction: .Down, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: familyPoint.frame)
        familyPopTip.popoverColor = PEAK_FAMILY_BLUE
        familyPopTip.textColor = UIColor.whiteColor()
        
        /// friend
        friendPopTip.offset = abs(POPTIP_OFFSET)
        friendPopTip.bubbleOffset = 20
        friendPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 15)
        friendPopTip.shouldDismissOnTapOutside = false
        friendPopTip.showText("Friends", direction: .Down, maxWidth: POPTIP_MAXWIDTH, inView: super.view, fromFrame: friendPoint.frame)
        friendPopTip.popoverColor = PEAK_FRIEND_CYAN
        friendPopTip.textColor = UIColor.whiteColor()


    }
    
    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello i loaded")
        //self.navigationController!.navigationBar.tintColor = PEAK_NAV_BAR_COLOR
        
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
