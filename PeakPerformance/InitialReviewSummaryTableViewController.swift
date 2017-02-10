//
//  InitialReviewSummaryTableViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 10/8/16.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip // https://github.com/andreamazz/AMPopTips

class InitialReviewSummaryTableViewController: UITableViewController {

    // MARK: - Properties
    
    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being viewed
    var summary: CurrentRealitySummary?
    
    /// KLA Diagram
    @IBOutlet weak var klaDiagramPeakPerformanceArea: CustomizableLabelView!
    
    
    /// Poptip
    let familyPopTip = AMPopTip()
    let healthPopTip = AMPopTip()
    let workPopTip = AMPopTip()
    let friendPopTip = AMPopTip()
    let emotionalSpiritualPopTip = AMPopTip()
    let personalDevPopTip = AMPopTip()
    let partnerPopTip = AMPopTip()
    let financialPopTip = AMPopTip()
  
    // MARK: - Outlet
    
    @IBOutlet weak var familyPoint: UIButton!
    
    @IBOutlet weak var friendPoint: UIButton!
    
    @IBOutlet weak var partnerPoint: UIButton!
    
    @IBOutlet weak var workPoint: UIButton!
    
    
    @IBOutlet weak var healthPoint: UIButton!
    
    @IBOutlet weak var personalPoint: UIButton!
    
    @IBOutlet weak var financePoint: UIButton!
    
    @IBOutlet weak var emotionalSpiritualPoint: UIButton!
    
    /// Textviews
    
    @IBOutlet weak var familyTextView: UITextView!
    
    @IBOutlet weak var friendTextView: UITextView!
    
    @IBOutlet weak var partnerTextView: UITextView!
    
    @IBOutlet weak var workTextView: UITextView!
    
    @IBOutlet weak var healthTextView: UITextView!
    
    @IBOutlet weak var personalTextView: UITextView!
    
    @IBOutlet weak var financeTextView: UITextView!
    
    @IBOutlet weak var emotionalSpiritualTextView: UITextView!
    
    
    // MARK: - Action
    
    @IBAction func familyPointPressed(_ sender: AnyObject) {
    }
    
    @IBAction func friendPointPressed(_ sender: AnyObject) {
    }
    
    @IBAction func partnerPointPressed(_ sender: AnyObject) {
    }
    
    @IBAction func workPointPressed(_ sender: AnyObject) {
    }
    
    @IBAction func healthPointPressed(_ sender: AnyObject) {
    }
    
    @IBAction func personalPointPressed(_ sender: AnyObject) {
    }
    
    @IBAction func financePointPressed(_ sender: AnyObject) {
    }
   
    @IBAction func emotionalSpritualPointPressed(_ sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = PEAK_NAV_BAR_COLOR
        
        displayPoints( )
        displayPopTips( )
        
        updateSummaryWithText( )
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

 
    }

    // MARK: - Method
    
    func displayPoints( ) {
        
        
        // Origin
        let xmidpoint = (self.view.frame.size.width/2) - (familyPoint.frame.size.width/2)
        let ymidpoint = (klaDiagramPeakPerformanceArea.frame.midY) - (familyPoint.frame.size.width/2)
        
        
        // Family point
        var familyFrame: CGRect = familyPoint.frame
        familyFrame.origin.x = xmidpoint
        familyFrame.origin.y = ymidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FAMILY]!)
        familyPoint.translatesAutoresizingMaskIntoConstraints = true
        familyPoint.frame = familyFrame
        
        // Financial point
        var financialFrame: CGRect = financePoint.frame
        financialFrame.origin.x = xmidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FINANCIAL]!)
        financialFrame.origin.y = ymidpoint
        financePoint.translatesAutoresizingMaskIntoConstraints = true
        financePoint.frame = financialFrame
        
        // Friend point
        var friendFrame: CGRect = friendPoint.frame
        friendFrame.origin.x = xmidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FRIENDSSOCIAL]!))
        friendFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FRIENDSSOCIAL]!))
        friendPoint.translatesAutoresizingMaskIntoConstraints = true
        friendPoint.frame = friendFrame
        
        // Health point
        var healthFrame: CGRect = healthPoint.frame
        healthFrame.origin.x = xmidpoint
        healthFrame.origin.y = ymidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_HEALTHFITNESS]!)
        healthPoint.translatesAutoresizingMaskIntoConstraints = true
        healthPoint.frame = healthFrame
        
        // Partner point
        var partnerFrame: CGRect = partnerPoint.frame
        partnerFrame.origin.x = xmidpoint + UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PARTNER]!)
        partnerFrame.origin.y = ymidpoint
        partnerPoint.translatesAutoresizingMaskIntoConstraints = true
        partnerPoint.frame = partnerFrame
        
        
        // Personal development point
        var personalDevelopmentFrame: CGRect = personalPoint.frame
        personalDevelopmentFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevelopmentFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalPoint.translatesAutoresizingMaskIntoConstraints = true
        personalPoint.frame = personalDevelopmentFrame
        
        
        // Work point
        var workFrame: CGRect = workPoint.frame
        workFrame.origin.x = xmidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_WORKBUSINESS]!))
        workFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_WORKBUSINESS]!))
        workPoint.translatesAutoresizingMaskIntoConstraints = true
        workPoint.frame = workFrame
        
        
        // Emotional spiritual point
        var emotionalSpiritualFrame: CGRect = workPoint.frame
        emotionalSpiritualFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualFrame.origin.y = ymidpoint + ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_EMOSPIRITUAL]!))
        emotionalSpiritualPoint.translatesAutoresizingMaskIntoConstraints = true
        emotionalSpiritualPoint.frame = emotionalSpiritualFrame
        
        
    }

    // BEN //
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
        personalDevPopTip.showText(SHORTENED_KLA_PERSONAL_TITLE, direction: .up, maxWidth: POPTIP_MAXWIDTH + 60, in: super.view, fromFrame: personalPoint.frame)
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
        
        let customFinancialView = UIView(frame: CGRect(x: financePoint.frame.origin.x, y: partnerPoint.frame.origin.y - POPTIP_OFFSET + 3, width: 60, height: 15))
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
        
        /// Family
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
  
    // END BEN //
    
    /// Updates the summary being reviewed with text from the text views.
    func updateSummaryWithText( )
    {
        guard let s = self.summary else
        {
            print("SMRVC: could not get summary")
            return
        }
        self.familyTextView.text = s.klaReasons[KLA_FAMILY]
        self.friendTextView.text = s.klaReasons[KLA_FRIENDSSOCIAL]
        self.partnerTextView.text = s.klaReasons[KLA_PARTNER]
        self.workTextView.text = s.klaReasons[KLA_WORKBUSINESS]
        self.healthTextView.text = s.klaReasons[KLA_HEALTHFITNESS]
        self.personalTextView.text = s.klaReasons[KLA_PERSONALDEV]
        self.financeTextView.text = s.klaReasons[KLA_FINANCIAL]
        self.emotionalSpiritualTextView.text = s.klaReasons[KLA_EMOSPIRITUAL]
    }
    

}
