//
//  SideMenuViewController.swift
//  PeakPerformance
//
//  Created by Bren on 23/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import Firebase

/**
    Class that controls the side menu. Also contains extension to SideMenu framework that handles set up.
 */
class SideMenuViewController: UITableViewController
{
    @IBOutlet weak var emailProfileLabel: UILabel!
    
    @IBOutlet weak var nameProfileLabel: UILabel!
    
    @IBOutlet weak var startDateProfileLabel: UILabel!
    var currentUser: User?
    
    var sb: UIStoryboard?
    
    /// Present an alert asking the user if they want to sign out.
    func signOut( )
    {
        let signOutAlertController = UIAlertController(title: SIGNOUT_ALERT_TITLE, message: SIGNOUT_ALERT_MSG, preferredStyle: .ActionSheet)
        let cancelSignOut = UIAlertAction(title: SIGNOUT_ALERT_CANCEL, style: .Cancel, handler: nil )
        let signOut = UIAlertAction(title: SIGNOUT_ALERT_CONFIRM, style: .Default ) { (action) in
            do
            {
                try FIRAuth.auth()?.signOut()
                print("SMVC: user has signed out") //DEBUG
                
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            self.performSegueWithIdentifier(UNWIND_TO_LOGIN, sender: self)
            
        }
        signOutAlertController.addAction(signOut); signOutAlertController.addAction(cancelSignOut)
        
        self.presentViewController(signOutAlertController, animated: true, completion: nil)
        
    }
    
    func goToMonthlyReview( )
    {
        //ask user if they want to go to history view to complete monthly reviews
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("changeIndex", object: nil)
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        //determine selected cell and perform associated action.
        if cell?.reuseIdentifier == SIGNOUT_CELL_ID
        {
            print("SMVC: sign out pressed")
            self.signOut( )
        }
        if cell?.reuseIdentifier == MONTHLYREVIEW_CELL_ID
        {
            print("SMVC: monthly review pressed")
            self.dismissViewControllerAnimated(true, completion: nil)
            self.goToMonthlyReview()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        guard let cu = currentUser else {
            return
            // couldn't get user
        }
        emailProfileLabel.text = cu.email
        nameProfileLabel.text = cu.fname
        
        //set month label
        let dateFormatter = NSDateFormatter( )
        dateFormatter.dateFormat = MONTH_YEAR_FORMAT_STRING
        let monthAsString = dateFormatter.stringFromDate(cu.startDate)
        startDateProfileLabel.text = "Started \(monthAsString)"
        print("SMVC: \(cu.email)") //DEBUG
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        guard let cu = currentUser else {
            return
            // couldn't get user
        }
        emailProfileLabel.text = cu.email
    }
  

}


