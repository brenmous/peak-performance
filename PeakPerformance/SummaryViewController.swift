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
    
    @IBAction func personalDevelopmentPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func financialPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func partnerPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func emotionalSpiritualPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func workPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func healthPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func friendPointPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func familyPointPressed(_ sender: AnyObject) {
        
    }
    // END BEN //
    
    @IBAction func weeklyButtonPressed(_ sender: AnyObject)
    {
        performSegue(withIdentifier: GO_TO_SECOND_SUMMARY_SEGUE, sender: self)
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

    /**
     Displays the points of 8 key life areas; Derives the origin (0,0) from the midpoint of the parent view and the biggest circle
     
     - Parameters:
     - None
     */
    // BEN //
    func displayPoints( ) {
        
    
        /// origin
        let xmidpoint = (self.view.frame.size.width/2) - (familyPoint.frame.size.width/2)
        let ymidpoint = (klaDiagramPeakPerformanceArea.frame.midY) - (familyPoint.frame.size.width/2)
        
        
        /// family point
        var familyFrame: CGRect = familyPoint.frame
        familyFrame.origin.x = xmidpoint
        familyFrame.origin.y = ymidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FAMILY]!)
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

    /**
     Displays the poptips of the 8 KLAs. All except financial and partner are custom poptips that were created with CGRect. 
     Family, financial, partner and health poptips include an if-statement to determine the direction of the pop up.
     
     - Parameters:
     - None
     */

    func displayPopTips( ) {

        var directionOfPopTip: CGFloat
        /// Health
        directionOfPopTip = UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_HEALTHFITNESS]!)
        
        /// determines when pop tip is in Peak Performance to set downward pop up direction
        if directionOfPopTip == PEAK_PERFORMANCE_HIGH {
            healthPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
            healthPopTip.offset = -POPTIP_OFFSET
            healthPopTip.showText(SHORTENED_KLA_HEALTH_TITLE, direction: .down, maxWidth: POPTIP_MAXWIDTH, in: super.view, fromFrame: healthPoint.frame)
        } else {
            healthPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 30)
            healthPopTip.offset = POPTIP_OFFSET
            healthPopTip.showText(SHORTENED_KLA_HEALTH_TITLE, direction: .up, maxWidth: POPTIP_MAXWIDTH, in: super.view, fromFrame: healthPoint.frame)
        }
        healthPopTip.shouldDismissOnTapOutside = false
        healthPopTip.popoverColor = PEAK_HEALTH_GREEN
        healthPopTip.textColor = UIColor.white
        
        
        /// Work
        workPopTip.offset = POPTIP_OFFSET
        workPopTip.bubbleOffset = 10
        workPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 7)
        workPopTip.shouldDismissOnTapOutside = false
        workPopTip.showText(SHORTENED_KLA_WORK_TITLE, direction: .up, maxWidth: POPTIP_MAXWIDTH, in: super.view, fromFrame: workPoint.frame)
        workPopTip.popoverColor = PEAK_WORK_YELLOW
        workPopTip.textColor = UIColor.white
        
        /// Personal Development
        personalDevPopTip.offset = POPTIP_OFFSET
        personalDevPopTip.bubbleOffset = -35
        personalDevPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 7)
        personalDevPopTip.shouldDismissOnTapOutside = false
        personalDevPopTip.showText(SHORTENED_KLA_PERSONAL_TITLE, direction: .up, maxWidth: POPTIP_MAXWIDTH + 60, in: super.view, fromFrame: personalDevelopmentPoint.frame)
        personalDevPopTip.popoverColor = PEAK_PERSONAL_ORANGE
        personalDevPopTip.textColor = UIColor.white
        
        
        /// Partner
        
        /// Custom View for horizontal pop tip
        directionOfPopTip = UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PARTNER]!)
        
        let customPartnerView = UIView(frame: CGRect(x: partnerPoint.frame.origin.x + POPTIP_OFFSET + 20, y: partnerPoint.frame.origin.y - POPTIP_OFFSET + 3, width: 50, height: 15))
        let customPartnerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 15))
        customPartnerLabel.numberOfLines = 1
        customPartnerLabel.text = SHORTENED_KLA_PARTNER_TITLE
        customPartnerLabel.textColor = UIColor.white
        customPartnerLabel.font = UIFont.systemFont(ofSize: 14)
        customPartnerView.addSubview(customPartnerLabel)
        
        /// determines when pop tip is in Peak Performance to set leftward pop up direction
        if directionOfPopTip >= PEAK_PERFORMANCE_LOW {
            partnerPopTip.offset = POPTIP_OFFSET + 20
            partnerPopTip.showCustomView(customPartnerView, direction: .left, in: self.view, fromFrame: customPartnerView.frame)
        } else {
            partnerPopTip.showCustomView(customPartnerView, direction: .right, in: self.view, fromFrame: customPartnerView.frame)
        }
        
        partnerPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH , height: POPTIP_ARROW_HEIGHT)
        partnerPopTip.shouldDismissOnTapOutside = false
        partnerPopTip.popoverColor = PEAK_PARTNER_PURPLE
        partnerPopTip.textColor = UIColor.white
        
        
        /// Financial
        
        /// Custom View for horizontal pop tip
        directionOfPopTip = UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FINANCIAL]!)
        
        let customFinancialView = UIView(frame: CGRect(x: financialPoint.frame.origin.x, y: partnerPoint.frame.origin.y - POPTIP_OFFSET + 3, width: 60, height: 15))
        let customFinancialLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 15))
        customFinancialLabel.numberOfLines = 1
        customFinancialLabel.text = SHORTENED_KLA_FINANCIAL_TITLE
        customFinancialLabel.textColor = UIColor.white
        customFinancialLabel.font = UIFont.systemFont(ofSize: 14)
        customFinancialView.addSubview(customFinancialLabel)
        
        /// determines when pop tip is in Peak Performance to set rightward pop up direction
        if directionOfPopTip >= PEAK_PERFORMANCE_LOW {
            financialPopTip.offset = POPTIP_OFFSET + 7
            financialPopTip.showCustomView(customFinancialView, direction: .right, in: self.view, fromFrame: customFinancialView.frame)
        } else {
            financialPopTip.showCustomView(customFinancialView, direction: .left, in: self.view, fromFrame: customFinancialView.frame)
        }
        financialPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        financialPopTip.shouldDismissOnTapOutside = false
        financialPopTip.popoverColor = PEAK_FINANCE_BLUE_GREEN

        
        /// Emotional/Spritual
        emotionalSpiritualPopTip.offset = abs(POPTIP_OFFSET)
        emotionalSpiritualPopTip.bubbleOffset = -100
        emotionalSpiritualPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 7)
        emotionalSpiritualPopTip.shouldDismissOnTapOutside = false
        emotionalSpiritualPopTip.showText(SHORTENED_KLA_EMOTIONAL_TITLE, direction: .down, maxWidth: POPTIP_MAXWIDTH + 60, in: super.view, fromFrame: emotionalSpiritualPoint.frame)
        emotionalSpiritualPopTip.popoverColor = PEAK_EMOTIONAL_VIOLET
        emotionalSpiritualPopTip.textColor = UIColor.white
        
        /// family
        directionOfPopTip = UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FAMILY]!)
        familyPopTip.shouldDismissOnTapOutside = false
        
        /// determines when pop tip is in Peak Performance to set upward pop up direction
        if directionOfPopTip >= PEAK_PERFORMANCE_LOW {
            familyPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
            familyPopTip.offset = POPTIP_OFFSET
            familyPopTip.showText(KLA_FAMILY, direction: .up, maxWidth: POPTIP_MAXWIDTH, in: super.view, fromFrame: familyPoint.frame)
            
        } else {
            familyPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 30)
            familyPopTip.offset = abs(POPTIP_OFFSET)
            familyPopTip.showText(KLA_FAMILY, direction: .down, maxWidth: POPTIP_MAXWIDTH, in: super.view, fromFrame: familyPoint.frame)
        }
        familyPopTip.popoverColor = PEAK_FAMILY_BLUE
        familyPopTip.textColor = UIColor.white
        
        /// friend
        friendPopTip.offset = abs(POPTIP_OFFSET)
        friendPopTip.bubbleOffset = 20
        friendPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT + 7)
        friendPopTip.shouldDismissOnTapOutside = false
        friendPopTip.showText(SHORTENED_KLA_FRIEND_TITLE, direction: .down, maxWidth: POPTIP_MAXWIDTH, in: super.view, fromFrame: friendPoint.frame)
        friendPopTip.popoverColor = PEAK_FRIEND_CYAN
        friendPopTip.textColor = UIColor.white

    }
    
    // MARK: - Overriden methods
    
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

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == GO_TO_SECOND_SUMMARY_SEGUE
        {
            let dvc = segue.destination as! SecondSummaryViewController
            dvc.summary = self.summary
        }
        
    }
    

}
