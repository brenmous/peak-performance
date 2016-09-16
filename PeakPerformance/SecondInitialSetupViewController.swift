//
//  SecondInitialSetupViewController.swift
//  PeakPerformance
//
//  Created by Bren on 16/09/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

class SecondInitialSetupViewController: UITableViewController {

    /// The currently logged in user.
    var currentUser: User?
    
    /// The summary being reviewed.
    var summary: MonthlySummary?
    
    
    // MARK: - Outlets

    // MARK: - Actions
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        /*
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
        */
        //performSegueWithIdentifier( GO_TO_TAB_BAR_SEGUE, sender: self)
        let tbvc = self.storyboard?.instantiateViewControllerWithIdentifier(TAB_BAR_VC) as! TabBarViewController
        tbvc.currentUser = self.currentUser
        self.presentViewController(tbvc, animated: true, completion: nil)
        
    }
    
    // MARK: - Methods
    /*
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
    } */
    
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
    
    // MARK: - Table view data source
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
     {
        if segue.identifier == GO_TO_TAB_BAR_SEGUE
        {
            let dvc = segue.destinationViewController as! TabBarViewController
            dvc.currentUser = self.currentUser
        }
     }
    
    
}


