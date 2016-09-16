//
//  SecondInitialSetupViewController.swift
//  PeakPerformance
//
//  Created by Bren on 16/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

//TODO: - Displaying current reality summary

class SecondInitialSetupViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: CurrentRealitySummary?
    
    
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
    
    // MARK: - Actions
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
        DataService.saveCurrentRealitySummary( cu, summary: s )

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


