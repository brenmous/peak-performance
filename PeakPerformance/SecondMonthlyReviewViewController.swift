//
//  SecondMonthlyReviewViewController.swift
//  PeakPerformance
//
//  Created by Bren on 8/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SecondMonthlyReviewViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: MonthlySummary?
    
    // MARK: - Outlets
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
    @IBOutlet weak var klaDiagramPeakPerformanceArea: CustomizableLabelView!

    
    // MARK: - Actions
    
    @IBAction func familyPointPressed(sender: AnyObject) {
    print("family button pressed")
    }
    
    @IBAction func friendPointPressed(sender: AnyObject) {
    print("friend button pressed")
    }
    
    @IBAction func healthPointPressed(sender: AnyObject) {
    print("health button pressed")
        
    }
    
    @IBAction func partnerPointPressed(sender: AnyObject) {
   print("partner button pressed")
    }
    
    @IBAction func financialPointPressed(sender: AnyObject) {
        print("financial button pressed")
    }
    
    @IBAction func personalDevelopmentPointPressed(sender: AnyObject) {
        print("personal dev button pressed")
    }
    
    @IBAction func workPointPressed(sender: AnyObject) {
        print("work button pressed")
    }

    @IBAction func emotionalSpiritualPointPressed(sender: AnyObject) {
        print("emotional/spiritual button pressed")
    }
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        self.updateSummaryWithText( )
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
        s.reviewed = true
        DataService.saveSummary( cu, summary: s )
        performSegueWithIdentifier( UNWIND_TO_HISTORY_SEGUE, sender: self)
        
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
        s.whatIsWorking = self.whatIsWorkingTextView.text
        s.whatIsNotWorking = self.whatIsNotWorkingTextView.text
        s.whatHaveIImproved = self.whatHaveIImprovedTextView.text
        s.doIHaveToChange = self.doIHaveToChangeTextView.text //TODO: - Temp. Make this radio buttons.
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
    
    // MARK: - Overriden methods

    // Function to diplay the points of 8 key life areas;
    // Derives the origin (0,0) from the midpoint of the parent view and the biggest circle
    func displayPoints( ) {
        
 
        // origin
        let xmidpoint = (self.view.frame.size.width/2) - (familyPoint.frame.size.width/2)
        let ymidpoint = (klaDiagramPeakPerformanceArea.frame.midY) - (familyPoint.frame.size.width/2)
        let increment: CGFloat = 120
        
        // family point
        var familyFrame: CGRect = familyPoint.frame
        familyFrame.origin.x = xmidpoint
        familyFrame.origin.y = ymidpoint + increment
        familyPoint.translatesAutoresizingMaskIntoConstraints = true
        familyPoint.frame = familyFrame
        
        // financial point
        var financialFrame: CGRect = financialPoint.frame
        financialFrame.origin.x = xmidpoint - increment
        financialFrame.origin.y = ymidpoint
        financialPoint.translatesAutoresizingMaskIntoConstraints = true
        financialPoint.frame = financialFrame
        
        // friend point
        var friendFrame: CGRect = friendPoint.frame
        friendFrame.origin.x = xmidpoint + increment
        friendFrame.origin.y = ymidpoint + increment
        friendPoint.translatesAutoresizingMaskIntoConstraints = true
        friendPoint.frame = friendFrame
    
        // health point
        var healthFrame: CGRect = healthPoint.frame
        healthFrame.origin.x = xmidpoint
        healthFrame.origin.y = ymidpoint - increment
        healthPoint.translatesAutoresizingMaskIntoConstraints = true
        healthPoint.frame = healthFrame
        
        // partner point
        var partnerFrame: CGRect = partnerPoint.frame
        partnerFrame.origin.x = xmidpoint + increment
        partnerFrame.origin.y = ymidpoint
        partnerPoint.translatesAutoresizingMaskIntoConstraints = true
        partnerPoint.frame = partnerFrame
        
        
        // personal development point
        var personalDevelopmentFrame: CGRect = personalDevelopmentPoint.frame
        personalDevelopmentFrame.origin.x = xmidpoint - increment
        personalDevelopmentFrame.origin.y = ymidpoint - increment
        personalDevelopmentPoint.translatesAutoresizingMaskIntoConstraints = true
        personalDevelopmentPoint.frame = personalDevelopmentFrame
        
        
        // work point
        var workFrame: CGRect = workPoint.frame
        workFrame.origin.x = xmidpoint + increment
        workFrame.origin.y = ymidpoint - increment
        workPoint.translatesAutoresizingMaskIntoConstraints = true
        workPoint.frame = workFrame
        
        
        // emotional spiritual point
        var emotionalSpiritualFrame: CGRect = workPoint.frame
        emotionalSpiritualFrame.origin.x = xmidpoint - increment
        emotionalSpiritualFrame.origin.y = ymidpoint + increment
        emotionalSpiritual.translatesAutoresizingMaskIntoConstraints = true
        emotionalSpiritual.frame = emotionalSpiritualFrame
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPoints( )
//        super.view.userInteractionEnabled = false
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
