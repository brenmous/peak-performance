//
//  SecondInitialSetupViewController.swift
//  PeakPerformance
//
//  Created by Bren on 16/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip

class SecondInitialSetupViewController: UITableViewController {

    // MARK: - Properties
    
    let dataService = DataService()
    
    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: CurrentRealitySummary?
    
    /// Poptip
    let popTip = AMPopTip()
    
    // MARK: - Outlets
    
    //*****these need to be hooked up******//
    @IBOutlet weak var familyTextView: UITextView!
    @IBOutlet weak var friendsTextView: UITextView!
    @IBOutlet weak var partnerTextView: UITextView!
    @IBOutlet weak var workTextView: UITextView!
    @IBOutlet weak var healthTextView: UITextView!
    @IBOutlet weak var personalTextView: UITextView!
    @IBOutlet weak var financeTextView: UITextView!
    @IBOutlet weak var emotionalTextView: UITextView!
    
    
    /// KLA Diagram
    @IBOutlet weak var klaDiagramPeakPerformanceArea: CustomizableLabelView!
    
    
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
    
    @IBAction func personalDevPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Personal Development", direction: .Up, maxWidth: 90, inView: super.view, fromFrame: personalDevPoint.frame)
        popTip.popoverColor = UIColor.orangeColor()
        popTip.textColor = UIColor.whiteColor()
        print("this is personal dev")
    }
    
    @IBAction func financialPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Financial", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: financialPoint.frame)
        popTip.popoverColor = UIColor.init(red: 47/355, green: 188/255, blue: 184/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    
    }

    
    @IBAction func emotionalSpiritualPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Emotional/Spiritual", direction: .Up, maxWidth: 90, inView: super.view, fromFrame: emotionalSpiritualPoint.frame)
        popTip.popoverColor = UIColor.init(red: 144/355, green: 85/255, blue: 153/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    
    }
    
    @IBAction func workPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Work", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: workPoint.frame)
        popTip.popoverColor = UIColor.yellowColor()
        popTip.textColor = UIColor.blackColor()
    
    }
    
    @IBAction func partnerPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Partner", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: partnerPoint.frame)
        popTip.popoverColor = UIColor.init(red: 193/355, green: 36/255, blue: 198/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    
    }
    

    @IBAction func healthPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Health", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: healthPoint.frame)
        popTip.popoverColor = UIColor.init(red: 191/355, green: 204/255, blue: 31/255, alpha: 1)
        popTip.textColor = UIColor.blackColor()
    }
    
    @IBAction func friendPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Friend", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: friendPoint.frame)
        popTip.popoverColor = UIColor.init(red: 101/355, green: 229/255, blue: 225/255, alpha: 1)
        popTip.textColor = UIColor.blackColor()
    }
    
    @IBAction func familyPointPressed(sender: AnyObject) {
        popTip.hide()
        popTip.showText("Family", direction: .Up, maxWidth: 60, inView: super.view, fromFrame: familyPoint.frame)
        popTip.popoverColor = UIColor.init(red: 32/355, green: 113/255, blue: 201/255, alpha: 1)
        popTip.textColor = UIColor.whiteColor()
    }

    
    
    
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        //self.updateSummaryWithText( )
        guard let s = self.summary else
        {
            print("SMRVC: error unwrapping summary")
            return
        }
        guard let cu = self.currentUser else
        {
            print("SMRVC: error unwrapping user")
            return
        }
        cu.yearlySummary = s
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
            print("SMRVC: could not get summary")
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
    // MARK: - Overriden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       displayPoints( )

        // Poptip
        popTip.offset = -50
        popTip.arrowSize = CGSize(width: 10, height: 10)
        popTip.shouldDismissOnTap = true
        
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
    
    //Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        self.view.endEditing(true)
    }
    

    

    
}


