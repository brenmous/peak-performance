//
//  MyValuesTableViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 9/1/16.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import Firebase


class MyValuesTableViewController: UITableViewController, UITextViewDelegate {

    /// The currently authenticated user.
    var currentUser: User?
    
    /// This view controller's data service.
    let dataService = DataService( )
    
// MARK: IBOutlet


    @IBOutlet weak var familyTextView: UITextView!
    @IBOutlet weak var friendsTextView: UITextView!
    @IBOutlet weak var partnerTextView: UITextView!
    @IBOutlet weak var workTextView: UITextView!
    @IBOutlet weak var healthTextView: UITextView!
    @IBOutlet weak var personalDevTextView: UITextView!
    @IBOutlet weak var financeTextView: UITextView!
    @IBOutlet weak var emotionalTextView: UITextView!
    
    @IBAction func saveMyValues(sender: AnyObject) {
        
        //dismiss keyboard
        self.view.endEditing(true)
        saveValues( )
        
        let saveNotificationAlertController = UIAlertController(title: SAVED_VALUES, message: nil, preferredStyle: .Alert)
        
        let confirm = UIAlertAction(title: CONFIRM_SAVE_VALUES, style: .Default, handler: nil)
        
        saveNotificationAlertController.addAction(confirm)
        presentViewController(saveNotificationAlertController, animated: true, completion: nil)
        
    }
    

    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
                presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    func saveValues( )
    {
        currentUser!.values[KLA_FAMILY] = familyTextView.text
        currentUser!.values[KLA_FRIENDSSOCIAL] = friendsTextView.text
        currentUser!.values[KLA_PARTNER] = partnerTextView.text
        currentUser!.values[KLA_WORKBUSINESS] = workTextView.text
        currentUser!.values[KLA_HEALTHFITNESS] = healthTextView.text
        currentUser!.values[KLA_PERSONALDEV] = personalDevTextView.text
        currentUser!.values[KLA_FINANCIAL] = financeTextView.text
        currentUser!.values[KLA_EMOSPIRITUAL] = emotionalTextView.text
        
        guard let cu = currentUser else
        {
            return
        }
        cu.values[KLA_FRIENDSSOCIAL] = friendsTextView.text
        dataService.saveValues(cu)
        print("MVVC: This is my financial goal \(cu.values[KLA_FINANCIAL]!)") //label debug strings please
    }
    /// Updates text views with details from the current my values (if available)
    func updateTextViews( )
    {
        guard let cu =  currentUser else
        {
            return
        }
        familyTextView.text = cu.values[KLA_FAMILY]
        friendsTextView.text = cu.values[KLA_FRIENDSSOCIAL]
        partnerTextView.text = cu.values[KLA_PARTNER]
        workTextView.text = cu.values[KLA_WORKBUSINESS]
        healthTextView.text = cu.values[KLA_HEALTHFITNESS]
        personalDevTextView.text = cu.values[KLA_PERSONALDEV]
        financeTextView.text = cu.values[KLA_FINANCIAL]
        emotionalTextView.text = cu.values[KLA_EMOSPIRITUAL]
        print("MVVC: textviews updated \(cu.values[KLA_FRIENDSSOCIAL])") // DEBUG
    }
    // MARK: Overridden methods
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if currentUser != nil
        {
            self.updateTextViews( )
        }
        
        //check if a monthly review is needed
        let alert = MonthlyReviewHelper(user: self.currentUser!).checkMonthlyReview()
        if alert != nil
        {
            self.presentViewController(alert!, animated: true, completion: nil)
        }
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tbvc = self.tabBarController as! TabBarViewController
        
        guard let cu = tbvc.currentUser else
        {
            return
        }
        self.currentUser = cu
        
        print("MVVC: got user \(cu.email) with \(cu.values.count) values")
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveValues( )
        
    }

    // MARK: - keyboard stuff
    /// Work around for dismissing keyboard on text view.
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder( )
//            validator.validate(self)
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
