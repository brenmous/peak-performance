//
//  MyValuesTableViewController.swift
//  PeakPerformance
//
//  Created by Benjamin Chiong on 9/1/16.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import AMPopTip

class MyValuesTableViewController: UITableViewController, UITextViewDelegate {

    let dataService = DataService()
    
    /// The currently authenticated user.
    var currentUser: User?

    
    // MARK: - Outlet
    let infoPopTip = AMPopTip()

    @IBOutlet weak var familyTextView: UITextView!
    @IBOutlet weak var friendsTextView: UITextView!
    @IBOutlet weak var partnerTextView: UITextView!
    @IBOutlet weak var workTextView: UITextView!
    @IBOutlet weak var healthTextView: UITextView!
    @IBOutlet weak var personalDevTextView: UITextView!
    @IBOutlet weak var financeTextView: UITextView!
    @IBOutlet weak var emotionalTextView: UITextView!

    @IBOutlet weak var familyPopTip: UIButton!
    
    @IBOutlet weak var friendsPopTip: UIButton!
    
    @IBOutlet weak var partnerPopTip: UIButton!
    
    @IBOutlet weak var workPopTip: UIButton!
    
    @IBOutlet weak var healthPopTip: UIButton!
    
    @IBOutlet weak var personalPopTip: UIButton!
    
    @IBOutlet weak var financePopTip: UIButton!
   
    @IBOutlet weak var emotionalPopTip: UIButton!
    
    // MARK: - Action
    
    @IBAction func familyInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(FAMILY_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(1), fromFrame: familyPopTip.frame)

    }
    
    @IBAction func friendsInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(FRIENDS_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(2), fromFrame: friendsPopTip.frame)

    }
    
    @IBAction func partnerInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(PARTNER_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(3), fromFrame: partnerPopTip.frame)
        
    }
    
    
    @IBAction func workInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(WORK_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(4), fromFrame: workPopTip.frame)
    }
    
    @IBAction func healthInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(HEALTH_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(5), fromFrame: healthPopTip.frame)
    }
    

    @IBAction func personalInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(PERSONAL_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(6), fromFrame: personalPopTip.frame)
    }
    
    @IBAction func financeInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(FINANCE_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(7), fromFrame: financePopTip.frame)
    }

    
    @IBAction func emotionalInfoPressed(sender: AnyObject) {
        infoPopTip.hide()
        infoPopTip.showText(EMOTIONAL_MESSAGE_HELP, direction: .Down, maxWidth: self.view.frame.width-10, inView: self.view.viewWithTag(8), fromFrame: emotionalPopTip.frame)
    }
    
    
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
        self.dataService.saveValues(cu)
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
        
        //check if a yearly review is needed
        if self.currentUser!.checkYearlyReview()
        {
            //inform user review is needed
            //self.currentUser!.allMonthlyReviewsFromLastYear()
            self.presentViewController(UIAlertController.AnnualReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
        }
            //only check for monthly reviews if the year hasn't changed, because if it has we know we need 12 months of reviews
        else
        {
            //check if a monthly review is needed
            if self.currentUser!.checkMonthlyReview()
            {
                self.presentViewController(UIAlertController.getReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
            }
        }

        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        self.tableView.reloadData()
    }
    
    // BEN //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Poptip setup
        infoPopTip.textAlignment = .Left
        infoPopTip.offset = POPTIP_OFFSET_MY_VALUES
        infoPopTip.arrowSize = CGSize(width: POPTIP_ARROW_WIDTH, height: POPTIP_ARROW_HEIGHT)
        infoPopTip.shouldDismissOnTap = true
        infoPopTip.shouldDismissOnTapOutside = true
        infoPopTip.popoverColor = PEAK_POPTIP_MY_VALUES_GRAY
        infoPopTip.textColor = UIColor.blackColor()
        
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
        
       /// Determines if a textfield has been edited and prompts the user to save the updated text
       if familyTextView.text != currentUser!.values[KLA_FAMILY] {
            showSaveAlert()
       } else if friendsTextView.text != currentUser!.values[KLA_FRIENDSSOCIAL] {
            showSaveAlert()
       } else if partnerTextView.text != currentUser!.values[KLA_PARTNER] {
            showSaveAlert()
       } else if workTextView.text != currentUser!.values[KLA_WORKBUSINESS] {
            showSaveAlert()
       } else if healthTextView.text != currentUser!.values[KLA_HEALTHFITNESS] {
            showSaveAlert()
       } else if personalDevTextView.text != currentUser!.values[KLA_PERSONALDEV] {
            showSaveAlert()
       } else if financeTextView.text != currentUser!.values[KLA_FINANCIAL] {
            showSaveAlert()
       } else if emotionalTextView.text != currentUser!.values[KLA_EMOSPIRITUAL] {
            showSaveAlert()
        }
        
    }
    // END BEN //
    
    func showSaveAlert() {
            let saveNotificationAlertController = UIAlertController(title: SAVE_VALUE_ALERT, message: CONFIRM_TO_SAVE_VALUES, preferredStyle: .Alert)
            
            let confirmSave = UIAlertAction(title: CONFIRM_SAVE_VALUES, style: .Default) { (action) in
                self.saveValues( )
            }
            let cancelSave = UIAlertAction(title: CANCEL_SAVE_VALUES, style: .Default, handler: nil)
            saveNotificationAlertController.addAction(confirmSave)
            saveNotificationAlertController.addAction(cancelSave)
            presentViewController(saveNotificationAlertController, animated: true, completion: nil)

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
    
    ///Dismisses keyboard when tap outside keyboard detected.
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        
        self.view.endEditing(true)
        super.touchesBegan(touchers, withEvent: event)
    }
    

}
