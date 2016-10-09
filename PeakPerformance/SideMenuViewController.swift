//
//  SideMenuViewController.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com - on 23/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import Firebase // https://firebase.google.com

/**
    Class that controls the side menu. Also contains extension to SideMenu framework that handles set up.
 */
class SideMenuViewController: UITableViewController
{
    // MARK: - Outlets
    @IBOutlet weak var emailProfileLabel: UILabel!
    
    @IBOutlet weak var nameProfileLabel: UILabel!
    
    @IBOutlet weak var startDateProfileLabel: UILabel!
    
    @IBOutlet weak var monthlyCounterLabel: CustomizableLabelView!
    
    // MARK: - Properties
    
    /// Currently authenticated user.
    var currentUser: User?
    
    /// Storyboard instance for instantiating view from storyboard.
    var sb: UIStoryboard?
    
    // MARK: - Methods
    
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
    
    /// Takes user to the History view.
    func goToMonthlyReview( )
    {
        //ask user if they want to go to history view to complete monthly reviews
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("changeIndex", object: nil)
    }
  
    /// Takes user to settings view.
    func goToSettings( )
    {
        //self.performSegueWithIdentifier("goToSettings", sender: self)
        let nav = self.storyboard?.instantiateViewControllerWithIdentifier(SETTINGS_NAV) as! UINavigationController
        let settingsVC = nav.viewControllers[0] as! SettingsViewController
        settingsVC.currentUser = self.currentUser
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: - Overridden methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        guard let c = cell else
        {
            print("SMVC - tableView(): could not get selected cell")
            return
        }
        
        //determine selected cell and perform associated action.
        switch c.reuseIdentifier
        {
        case SIGNOUT_CELL_ID?:
            self.signOut()
            
        case MONTHLYREVIEW_CELL_ID?:
            self.dismissViewControllerAnimated(true, completion: nil)
            self.goToMonthlyReview()
            
        case SETTINGS_CELL_ID?:
            self.goToSettings()
            
        default:
            break
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
        
        // set month counter
        let counter = self.currentUser!.numberOfUnreviwedSummaries()
        
        if counter == 0 {
            monthlyCounterLabel.hidden = true
        } else {
           monthlyCounterLabel.text = String(self.currentUser!.numberOfUnreviwedSummaries())
        }
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


