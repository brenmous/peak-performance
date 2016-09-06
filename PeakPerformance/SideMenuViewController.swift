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
    
    var currentUser: User?
    
    var sb: UIStoryboard?
    
    /// Present an alert asking the user if they want to sign out.
    func signOut( )
    {
        let signOutAlertController = UIAlertController(title: SIGNOUT_ALERT_TITLE, message: SIGNOUT_ALERT_MSG, preferredStyle: .ActionSheet)
        let signOut = UIAlertAction(title: SIGNOUT_ALERT_CANCEL, style: .Cancel, handler: nil )
        let cancelSignOut = UIAlertAction(title: SIGNOUT_ALERT_CONFIRM, style: .Default ) { (action) in
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

extension SideMenuManager
{
    /// Set up side menu in view controllers that should be able to display it.
    public class func setUpSideMenu( sb: UIStoryboard, user: User )
    {
        SideMenuManager.menuLeftNavigationController = UISideMenuNavigationController( )
        SideMenuManager.menuLeftNavigationController?.navigationBarHidden = true // hides the navigation bar
        SideMenuManager.menuLeftNavigationController?.leftSide = true
        let smvc = sb.instantiateViewControllerWithIdentifier(SIDE_MENU_VC) as! SideMenuViewController
        smvc.currentUser = user
        smvc.sb = sb
        SideMenuManager.menuLeftNavigationController?.setViewControllers([smvc], animated: true)
        
        // Pan Gestures 
        
        SideMenuManager.menuAddPanGestureToPresent(toView: (menuLeftNavigationController?.navigationBar)!)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (menuLeftNavigationController?.navigationBar)!)

        // Customize side menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .MenuSlideIn
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuBlurEffectStyle = .Dark
        SideMenuManager.menuAnimationFadeStrength = 0.5
    }

}

