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

class SideMenuViewController: UITableViewController
{
    @IBOutlet weak var emailProfileLabel: UILabel!
    
    var currentUser: User?
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
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == SIGNOUT_CELL_ID
        {
            self.signOut( )
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
        print("\(cu.email)")
        
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
    public class func setUpSideMenu( sb: UIStoryboard )
    {
        SideMenuManager.menuLeftNavigationController = UISideMenuNavigationController( )
        SideMenuManager.menuLeftNavigationController?.navigationBarHidden = true
        SideMenuManager.menuLeftNavigationController?.leftSide = true
        let smvc = sb.instantiateViewControllerWithIdentifier(SIDE_MENU_VC)
        SideMenuManager.menuLeftNavigationController?.setViewControllers([smvc], animated: true)
        
        // Pan Gestures
//        SideMenuManager.menuAddPanGestureToPresent(toView: (self.menuLeftNavigationController?.navigationBar)!)
//        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: (self.menuLeftNavigationController?.view)!)
        SideMenuManager.menuAnimationBackgroundColor = UIColor(red: 199/255, green: 210/255, blue: 37/255, alpha: 1)
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .MenuSlideIn
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuBlurEffectStyle = .Light
        
    }
}

