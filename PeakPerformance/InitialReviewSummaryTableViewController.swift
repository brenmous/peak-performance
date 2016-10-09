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
    
    @IBAction func familyPointPressed(sender: AnyObject) {
    }
    
    @IBAction func friendPointPressed(sender: AnyObject) {
    }
    
    @IBAction func partnerPointPressed(sender: AnyObject) {
    }
    
    @IBAction func workPointPressed(sender: AnyObject) {
    }
    
    @IBAction func healthPointPressed(sender: AnyObject) {
    }
    
    @IBAction func personalPointPressed(sender: AnyObject) {
    }
    
    @IBAction func financePointPressed(sender: AnyObject) {
    }
   
    @IBAction func emotionalSpritualPointPressed(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPoints( )
        displayPopTips( )
        updateSummaryWithText( )
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

 
    }

    // MARK: - Method
    
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
        var financialFrame: CGRect = financePoint.frame
        financialFrame.origin.x = xmidpoint - UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_FINANCIAL]!)
        financialFrame.origin.y = ymidpoint
        financePoint.translatesAutoresizingMaskIntoConstraints = true
        financePoint.frame = financialFrame
        
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
        var personalDevelopmentFrame: CGRect = personalPoint.frame
        personalDevelopmentFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevelopmentFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalPoint.translatesAutoresizingMaskIntoConstraints = true
        personalPoint.frame = personalDevelopmentFrame
        
        
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
                
        /// family
        familyPopTip.offset = OFFSET
        familyPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        familyPopTip.shouldDismissOnTapOutside = false
        familyPopTip.showText(KLA_FAMILY, direction: .Up, maxWidth: MAXWIDTH, inView: super.view, fromFrame: familyPoint.frame)
        familyPopTip.popoverColor = PEAK_FAMILY_BLUE
        familyPopTip.textColor = UIColor.whiteColor()
        
        /// friend
        friendPopTip.offset = OFFSET
        friendPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        friendPopTip.shouldDismissOnTapOutside = false
        friendPopTip.showText(KLA_FRIENDSSOCIAL, direction: .Up, maxWidth: MAXWIDTH, inView: super.view, fromFrame: friendPoint.frame)
        friendPopTip.popoverColor = PEAK_FRIEND_CYAN
        friendPopTip.textColor = UIColor.blackColor()
        
        /// Health
        healthPopTip.offset = OFFSET
        healthPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        healthPopTip.shouldDismissOnTapOutside = false
        healthPopTip.showText(KLA_HEALTHFITNESS, direction: .Up, maxWidth: MAXWIDTH, inView: super.view, fromFrame: healthPoint.frame)
        healthPopTip.popoverColor = PEAK_HEALTH_GREEN
        healthPopTip.textColor = UIColor.blackColor()
        
        
        /// Partner
        partnerPopTip.offset = OFFSET
        partnerPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        partnerPopTip.shouldDismissOnTapOutside = false
        partnerPopTip.showText(KLA_PARTNER, direction: .Up, maxWidth: MAXWIDTH, inView: super.view, fromFrame: partnerPoint.frame)
        partnerPopTip.popoverColor = PEAK_PARTNER_PURPLE
        partnerPopTip.textColor = UIColor.whiteColor()
        
        
        /// Financial
        financialPopTip.offset = OFFSET
        financialPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        financialPopTip.shouldDismissOnTapOutside = false
        financialPopTip.showText(KLA_FINANCIAL, direction: .Up, maxWidth: MAXWIDTH, inView: super.view, fromFrame: financePoint.frame)
        financialPopTip.popoverColor = PEAK_FINANCE_BLUE_GREEN
        financialPopTip.textColor = UIColor.whiteColor()
        
        
        /// Personal Development
        personalDevPopTip.offset = OFFSET
        personalDevPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        personalDevPopTip.shouldDismissOnTapOutside = false
        personalDevPopTip.showText(KLA_PERSONALDEV, direction: .Up, maxWidth: MAXWIDTH + 30, inView: super.view, fromFrame: personalPoint.frame)
        personalDevPopTip.popoverColor = UIColor.orangeColor()
        personalDevPopTip.textColor = UIColor.whiteColor()
        
        
        /// Work
        workPopTip.offset = OFFSET
        workPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        workPopTip.shouldDismissOnTapOutside = false
        workPopTip.showText(KLA_WORKBUSINESS, direction: .Up, maxWidth: MAXWIDTH, inView: super.view, fromFrame: workPoint.frame)
        workPopTip.popoverColor = UIColor.yellowColor()
        workPopTip.textColor = UIColor.blackColor()
        
        
        /// Emotional/Spritual
        emotionalSpiritualPopTip.offset = OFFSET
        emotionalSpiritualPopTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        emotionalSpiritualPopTip.shouldDismissOnTapOutside = false
        emotionalSpiritualPopTip.showText(KLA_EMOSPIRITUAL, direction: .Up, maxWidth: MAXWIDTH+30, inView: super.view, fromFrame: emotionalSpiritualPoint.frame)
        emotionalSpiritualPopTip.popoverColor = PEAK_EMOTIONAL_VIOLET
        emotionalSpiritualPopTip.textColor = UIColor.whiteColor()
        
        
    }
    
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



}
