//
//  SecondInitialSetupViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 16/09/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip // https://github.com/andreamazz/AMPopTip

class SecondInitialSetupViewController: UITableViewController {

    // MARK: - Properties
    
    /// DataService instance for interacting with Firebase database.
    let dataService = DataService()
    
    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: CurrentRealitySummary?
    
    let popTip = AMPopTip()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var familyTextView: UITextView!

    @IBOutlet weak var friendsTextView: UITextView!
    
    @IBOutlet weak var partnerTextView: UITextView!
    
    @IBOutlet weak var healthTextView: UITextView!
    
    @IBOutlet weak var personalTextView: UITextView!
    
    @IBOutlet weak var financeTextView: UITextView!
   
    @IBOutlet weak var emotionalTextView: UITextView!
    
    
    /// KLA Diagram
    @IBOutlet weak var klaDiagramPeakPerformanceArea: CustomizableLabelView!
    
    @IBOutlet weak var workTextView: UITextView!
    
    /// KLA Points
    @IBOutlet weak var personalDevPoint: UIButton!
    
    @IBOutlet weak var financialPoint: UIButton!
    
    @IBOutlet weak var emotionalSpiritualPoint: UIButton!
    
    @IBOutlet weak var workPoint: UIButton!
    
    @IBOutlet weak var partnerPoint: UIButton!

    @IBOutlet weak var healthPoint: UIButton!
    
    @IBOutlet weak var friendPoint: UIButton!
    
    @IBOutlet weak var familyPoint: UIButton!
    
    // MARK: - Actions
    
    //// BEN ///
    @IBAction func personalDevPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_PERSONALDEV, direction: .Up, maxWidth: 90, inView: super.view, fromFrame: personalDevPoint.frame)
        popTip.popoverColor = UIColor.orangeColor()
        popTip.textColor = UIColor.whiteColor()
    }
    
    @IBAction func financialPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_FINANCIAL, direction: .Up, maxWidth: 60, inView: super.view, fromFrame: financialPoint.frame)
        popTip.popoverColor = PEAK_FINANCE_BLUE_GREEN
        popTip.textColor = UIColor.whiteColor()
    
    }

    @IBAction func emotionalSpiritualPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_EMOSPIRITUAL, direction: .Up, maxWidth: 90, inView: super.view, fromFrame: emotionalSpiritualPoint.frame)
        popTip.popoverColor = PEAK_EMOTIONAL_VIOLET
        popTip.textColor = UIColor.whiteColor()
    
    }
    
    @IBAction func workPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_WORKBUSINESS, direction: .Up, maxWidth: 60, inView: super.view, fromFrame: workPoint.frame)
        popTip.popoverColor = UIColor.yellowColor()
        popTip.textColor = UIColor.blackColor()
    
    }
    
    @IBAction func partnerPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_PARTNER, direction: .Up, maxWidth: 60, inView: super.view, fromFrame: partnerPoint.frame)
        popTip.popoverColor = PEAK_PARTNER_PURPLE
        popTip.textColor = UIColor.whiteColor()
    
    }
    
    @IBAction func healthPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_HEALTHFITNESS, direction: .Up, maxWidth: 60, inView: super.view, fromFrame: healthPoint.frame)
        popTip.popoverColor = PEAK_HEALTH_GREEN
        popTip.textColor = UIColor.blackColor()
    }
    
    @IBAction func friendPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_FRIENDSSOCIAL, direction: .Up, maxWidth: 60, inView: super.view, fromFrame: friendPoint.frame)
        popTip.popoverColor = PEAK_FRIEND_CYAN
        popTip.textColor = UIColor.blackColor()
    }
    
    @IBAction func familyPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText(KLA_FAMILY, direction: .Up, maxWidth: 60, inView: super.view, fromFrame: familyPoint.frame)
        popTip.popoverColor = PEAK_FAMILY_BLUE
        popTip.textColor = UIColor.whiteColor()
    }
    /// END BEN ///
    
    
    
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        guard let s = self.summary else { return }
        guard let cu = self.currentUser else { return }
        cu.initialSummary = s
        self.dataService.saveCurrentRealitySummary( cu, summary: s )
        let tbvc = self.storyboard?.instantiateViewControllerWithIdentifier(TAB_BAR_VC) as! TabBarViewController
        tbvc.currentUser = self.currentUser
        self.presentViewController(tbvc, animated: true, completion: nil)
        
    }
    
    // MARK: - Methods
    
    /// Updates the summary being reviewed with text from the text views.
    func updateSummaryWithText( )
    {
        guard let s = self.summary else
        {
            return
        }
        self.familyTextView.text = s.klaReasons[KLA_FAMILY]
        self.friendsTextView.text = s.klaReasons[KLA_FRIENDSSOCIAL]
        self.partnerTextView.text = s.klaReasons[KLA_PARTNER]
        self.workTextView.text = s.klaReasons[KLA_WORKBUSINESS]
        self.healthTextView.text = s.klaReasons[KLA_HEALTHFITNESS]
        self.personalTextView.text = s.klaReasons[KLA_PERSONALDEV]
        self.financeTextView.text = s.klaReasons[KLA_FINANCIAL]
        self.emotionalTextView.text = s.klaReasons[KLA_EMOSPIRITUAL]
    }

    /// BEN ///
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
        var personalDevFrame: CGRect = personalDevPoint.frame
        personalDevFrame.origin.x = xmidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevFrame.origin.y = ymidpoint - ((sqrt(2)/2) * UITableViewController.getIncrementFromRating(summary!.klaRatings[KLA_PERSONALDEV]!))
        personalDevPoint.translatesAutoresizingMaskIntoConstraints = true
        personalDevPoint.frame = personalDevFrame
        
        
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
    /// END BEN ///
    
    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateSummaryWithText( )
        displayPoints( )

        /// BEN ///
        // Poptip
        popTip.offset = OFFSET
        popTip.arrowSize = CGSize(width: ARROW_WIDTH, height: ARROW_HEIGHT)
        popTip.shouldDismissOnTap = true
        /// END BEN ///
    }
    
    
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
}


